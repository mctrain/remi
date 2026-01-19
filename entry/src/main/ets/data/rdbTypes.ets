import relationalStore from '@ohos.data.relationalStore'

export interface ResultSet {
  rowCount: number
  goToFirstRow(): boolean
  goToNextRow(): boolean
  getColumnIndex(name: string): number
  isColumnNull(index: number): boolean
  getString(index: number): string
  getLong(index: number): number
  getDouble(index: number): number
  close(): void
}

export class Predicates {
  readonly table: string
  private equalColumns: string[] = []
  private equalValues: Array<string | number> = []

  constructor(table: string) {
    this.table = table
  }

  equalTo(column: string, value: string | number): Predicates {
    this.equalColumns.push(column)
    this.equalValues.push(value)
    return this
  }

  toSystem(): relationalStore.RdbPredicates {
    const predicates = new relationalStore.RdbPredicates(this.table)
    for (let i = 0; i < this.equalColumns.length; i++) {
      predicates.equalTo(this.equalColumns[i], this.equalValues[i])
    }
    return predicates
  }
}

export interface Store {
  insert(table: string, values: relationalStore.ValuesBucket): Promise<number>
  update(table: string, values: relationalStore.ValuesBucket, predicates?: Predicates): Promise<number>
  delete(table: string, predicates?: Predicates): Promise<number>
  query(predicates: Predicates): Promise<ResultSet>
  querySql(sql: string): Promise<ResultSet>
}

export class SystemResultSet implements ResultSet {
  private readonly inner: relationalStore.ResultSet

  constructor(inner: relationalStore.ResultSet) {
    this.inner = inner
  }

  get rowCount(): number {
    return this.inner.rowCount
  }

  goToFirstRow(): boolean {
    return this.inner.goToFirstRow()
  }

  goToNextRow(): boolean {
    return this.inner.goToNextRow()
  }

  getColumnIndex(name: string): number {
    return this.inner.getColumnIndex(name)
  }

  isColumnNull(index: number): boolean {
    return this.inner.isColumnNull(index)
  }

  getString(index: number): string {
    return this.inner.getString(index)
  }

  getLong(index: number): number {
    return this.inner.getLong(index)
  }

  getDouble(index: number): number {
    return this.inner.getDouble(index)
  }

  close(): void {
    this.inner.close()
  }
}

export class SystemStore implements Store {
  private readonly inner: relationalStore.RdbStore

  constructor(inner: relationalStore.RdbStore) {
    this.inner = inner
  }

  async insert(table: string, values: relationalStore.ValuesBucket): Promise<number> {
    return this.inner.insert(table, values)
  }

  async update(table: string, values: relationalStore.ValuesBucket, predicates?: Predicates): Promise<number> {
    if (!predicates) {
      throw new Error('Predicates are required for update')
    }
    return this.inner.update(values, predicates.toSystem())
  }

  async delete(table: string, predicates?: Predicates): Promise<number> {
    if (!predicates) {
      throw new Error('Predicates are required for delete')
    }
    return this.inner.delete(predicates.toSystem())
  }

  async query(predicates: Predicates): Promise<ResultSet> {
    const rs = await this.inner.query(predicates.toSystem())
    return new SystemResultSet(rs)
  }

  async querySql(sql: string): Promise<ResultSet> {
    const rs = await this.inner.querySql(sql)
    return new SystemResultSet(rs)
  }
}
