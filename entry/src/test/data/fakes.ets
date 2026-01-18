import relationalStore from '@ohos.data.relationalStore'
import type common from '@ohos.app.ability.common'
import { Database } from '../../main/ets/data/db'

type RowValue = string | number | null

class FakeRow {
  private keys: string[] = []
  private values: RowValue[] = []

  set(key: string, value: RowValue): void {
    const index = this.keys.indexOf(key)
    if (index >= 0) {
      this.values[index] = value
      return
    }
    this.keys.push(key)
    this.values.push(value)
  }

  get(key: string): RowValue {
    const index = this.keys.indexOf(key)
    if (index < 0) {
      return null
    }
    return this.values[index]
  }

  getKeys(): string[] {
    return this.keys
  }

  clone(): FakeRow {
    const row = new FakeRow()
    for (let i = 0; i < this.keys.length; i++) {
      row.set(this.keys[i], this.values[i])
    }
    return row
  }
}

class FakeResultSet implements relationalStore.ResultSet {
  rowCount: number
  private rows: FakeRow[]
  private columns: string[]
  private index: number = -1

  constructor(rows: FakeRow[]) {
    this.rows = rows
    this.columns = rows.length > 0 ? rows[0].getKeys() : []
    this.rowCount = rows.length
  }

  goToFirstRow(): boolean {
    if (this.rowCount === 0) {
      return false
    }
    this.index = 0
    return true
  }

  goToNextRow(): boolean {
    if (this.index + 1 >= this.rowCount) {
      return false
    }
    this.index += 1
    return true
  }

  getColumnIndex(name: string): number {
    return this.columns.indexOf(name)
  }

  isColumnNull(index: number): boolean {
    const name = this.columns[index]
    const value = this.rows[this.index].get(name)
    return value === null
  }

  getString(index: number): string {
    const name = this.columns[index]
    const value = this.rows[this.index].get(name)
    if (value === null) {
      return ''
    }
    return String(value)
  }

  getLong(index: number): number {
    const name = this.columns[index]
    const value = this.rows[this.index].get(name)
    if (value === null) {
      return 0
    }
    return Number(value)
  }

  getDouble(index: number): number {
    return this.getLong(index)
  }

  close(): void {}
}

class FakeRdbStore implements relationalStore.RdbStore {
  private places: FakeRow[] = []
  private visits: FakeRow[] = []

  private getTable(table: string): FakeRow[] {
    if (table === 'places') {
      return this.places
    }
    if (table === 'visits') {
      return this.visits
    }
    return []
  }

  async insert(table: string, values: relationalStore.ValuesBucket): Promise<number> {
    const row = new FakeRow()
    if (table === 'places') {
      row.set('id', values['id'] as string)
      row.set('name', values['name'] as string)
      row.set('countryCode', (values['countryCode'] as string) ?? null)
      row.set('city', (values['city'] as string) ?? null)
      row.set('lat', values['lat'] as number)
      row.set('lon', values['lon'] as number)
    } else if (table === 'visits') {
      row.set('id', values['id'] as string)
      row.set('placeId', values['placeId'] as string)
      row.set('visitedAt', values['visitedAt'] as number)
      row.set('note', (values['note'] as string) ?? null)
    }
    this.getTable(table).push(row)
    return 1
  }

  async update(values: relationalStore.ValuesBucket, predicates?: relationalStore.RdbPredicates): Promise<number> {
    const rows = this.resolveRows(predicates)
    // This fake updates all rows in the selected table.
    for (const row of rows) {
      for (const key in values) {
        const value = values[key] as RowValue
        row.set(key, value)
      }
    }
    return rows.length
  }

  async delete(predicates?: relationalStore.RdbPredicates): Promise<number> {
    const rows = this.resolveRows(predicates)
    const removed = rows.length
    // This fake deletes all rows in the selected table.
    for (const row of rows) {
      // no-op: cleared below
    }
    const tableName = this.getTableName(predicates)
    if (tableName === 'places') {
      this.places = []
    } else if (tableName === 'visits') {
      this.visits = []
    }
    return removed
  }

  async query(predicates: relationalStore.RdbPredicates): Promise<relationalStore.ResultSet> {
    const rows = this.resolveRows(predicates)
    const clones: FakeRow[] = []
    for (const row of rows) {
      clones.push(row.clone())
    }
    return new FakeResultSet(clones)
  }

  async querySql(sql: string): Promise<relationalStore.ResultSet> {
    if (sql.indexOf('FROM visits INNER JOIN places') < 0) {
      return new FakeResultSet([])
    }

    const outRows: FakeRow[] = []
    for (const visit of this.visits) {
      const visitPlaceId = visit.get('placeId')
      let foundPlace: FakeRow | null = null
      for (const place of this.places) {
        if (place.get('id') === visitPlaceId) {
          foundPlace = place
          break
        }
      }
      if (!foundPlace) {
        continue
      }

      const row = new FakeRow()
      row.set('visitId', visit.get('id'))
      row.set('placeId', visit.get('placeId'))
      row.set('visitedAt', visit.get('visitedAt'))
      row.set('note', visit.get('note'))

      row.set('place_id', foundPlace.get('id'))
      row.set('place_name', foundPlace.get('name'))
      row.set('place_countryCode', foundPlace.get('countryCode'))
      row.set('place_city', foundPlace.get('city'))
      row.set('place_lat', foundPlace.get('lat'))
      row.set('place_lon', foundPlace.get('lon'))

      outRows.push(row)
    }

    return new FakeResultSet(outRows)
  }

  private resolveRows(predicates?: relationalStore.RdbPredicates): FakeRow[] {
    const tableName = this.getTableName(predicates)
    if (tableName.length === 0) {
      return []
    }
    return this.getTable(tableName)
  }

  private getTableName(predicates?: relationalStore.RdbPredicates): string {
    if (!predicates) {
      return ''
    }
    // RdbPredicates in OHOS exposes tableName.
    return predicates.tableName
  }
}

export class TestDatabase extends Database {
  private readonly fakeStore: relationalStore.RdbStore

  constructor() {
    super()
    this.fakeStore = new FakeRdbStore()
  }

  async open(context: common.UIAbilityContext): Promise<relationalStore.RdbStore> {
    this.store = this.fakeStore
    return this.fakeStore
  }

  async close(): Promise<void> {
    this.store = undefined
  }
}
