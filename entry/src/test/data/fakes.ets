import type common from '@ohos.app.ability.common'
import relationalStore from '@ohos.data.relationalStore'
import { Database } from '../../main/ets/data/db'
import { Predicates, type ResultSet, type Store } from '../../main/ets/data/rdbTypes'

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

class FakeResultSet implements ResultSet {
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

class FakeStore implements Store {
  private places: FakeRow[] = []
  private visits: FakeRow[] = []

  async insert(table: string, values: relationalStore.ValuesBucket): Promise<number> {
    const row = new FakeRow()

    if (table === 'places') {
      row.set('id', values['id'] as string)
      row.set('name', values['name'] as string)
      row.set('countryCode', (values['countryCode'] as string) ?? null)
      row.set('city', (values['city'] as string) ?? null)
      row.set('lat', values['lat'] as number)
      row.set('lon', values['lon'] as number)
      this.places.push(row)
      return 1
    }

    if (table === 'visits') {
      row.set('id', values['id'] as string)
      row.set('placeId', values['placeId'] as string)
      row.set('visitedAt', values['visitedAt'] as number)
      row.set('note', (values['note'] as string) ?? null)
      this.visits.push(row)
      return 1
    }

    return 0
  }

  async update(table: string, values: relationalStore.ValuesBucket, predicates?: Predicates): Promise<number> {
    const rows = this.resolveRows(table)

    if (table === 'visits') {
      for (let i = 0; i < rows.length; i++) {
        const row = rows[i]
        if (values['placeId'] !== undefined) {
          row.set('placeId', values['placeId'] as string)
        }
        if (values['visitedAt'] !== undefined) {
          row.set('visitedAt', values['visitedAt'] as number)
        }
        if (values['note'] !== undefined) {
          row.set('note', (values['note'] as string) ?? null)
        }
      }
      return rows.length
    }

    if (table === 'places') {
      for (let i = 0; i < rows.length; i++) {
        const row = rows[i]
        if (values['name'] !== undefined) {
          row.set('name', values['name'] as string)
        }
        if (values['countryCode'] !== undefined) {
          row.set('countryCode', (values['countryCode'] as string) ?? null)
        }
        if (values['city'] !== undefined) {
          row.set('city', (values['city'] as string) ?? null)
        }
        if (values['lat'] !== undefined) {
          row.set('lat', values['lat'] as number)
        }
        if (values['lon'] !== undefined) {
          row.set('lon', values['lon'] as number)
        }
      }
      return rows.length
    }

    return 0
  }

  async delete(table: string, predicates?: Predicates): Promise<number> {
    const rows = this.resolveRows(table)
    const removed = rows.length

    if (removed === 0) {
      return 0
    }

    if (table === 'places') {
      this.places = []
      return removed
    }

    if (table === 'visits') {
      this.visits = []
      return removed
    }

    return 0
  }

  async query(predicates: Predicates): Promise<ResultSet> {
    const rows = this.resolveRows(predicates.table)
    const clones: FakeRow[] = []
    for (let i = 0; i < rows.length; i++) {
      clones.push(rows[i].clone())
    }
    return new FakeResultSet(clones)
  }

  async querySql(sql: string): Promise<ResultSet> {
    if (sql.indexOf('FROM visits INNER JOIN places') < 0) {
      return new FakeResultSet([])
    }

    const out: FakeRow[] = []

    for (let visitIndex = 0; visitIndex < this.visits.length; visitIndex++) {
      const visit = this.visits[visitIndex]
      const visitPlaceId = visit.get('placeId')

      let foundPlace: FakeRow | null = null
      for (let placeIndex = 0; placeIndex < this.places.length; placeIndex++) {
        const place = this.places[placeIndex]
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

      out.push(row)
    }

    return new FakeResultSet(out)
  }

  private resolveRows(table: string): FakeRow[] {
    if (table === 'places') {
      return this.places
    }
    if (table === 'visits') {
      return this.visits
    }
    return []
  }
}

export class TestDatabase extends Database {
  private readonly storeImpl: Store

  constructor() {
    super()
    this.storeImpl = new FakeStore()
  }

  async open(context: common.UIAbilityContext): Promise<void> {
    // Not used by tests; repositories use getStoreWrapper().
    throw new Error('TestDatabase.open is not supported in unit tests')
  }

  getStoreWrapper(): Store | undefined {
    return this.storeImpl
  }
}
