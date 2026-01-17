import relationalStore from '@ohos.data.relationalStore';

type Row = Record<string, number | string | null>;

class FakeResultSet {
  rowCount: number;
  private rows: Row[];
  private columns: string[];
  private index: number = -1;

  constructor(rows: Row[]) {
    this.rows = rows;
    this.columns = rows.length > 0 ? Object.keys(rows[0]) : [];
    this.rowCount = rows.length;
  }

  goToFirstRow(): boolean {
    if (this.rowCount === 0) {
      return false;
    }
    this.index = 0;
    return true;
  }

  goToNextRow(): boolean {
    if (this.index + 1 >= this.rowCount) {
      return false;
    }
    this.index += 1;
    return true;
  }

  getColumnIndex(name: string): number {
    return this.columns.indexOf(name);
  }

  isColumnNull(index: number): boolean {
    const name = this.columns[index];
    return this.rows[this.index][name] === null || this.rows[this.index][name] === undefined;
  }

  getString(index: number): string {
    const name = this.columns[index];
    return String(this.rows[this.index][name] ?? '');
  }

  getLong(index: number): number {
    const name = this.columns[index];
    return Number(this.rows[this.index][name] ?? 0);
  }

  getDouble(index: number): number {
    const name = this.columns[index];
    return Number(this.rows[this.index][name] ?? 0);
  }

  close(): void {}
}

class FakeRdbStore {
  private tables: Record<string, Row[]> = {
    places: [],
    visits: [],
    media: [],
    tags: [],
    achievements: []
  };

  async insert(table: string, values: relationalStore.ValuesBucket): Promise<number> {
    const row = { ...(values as Row) };
    this.tables[table].push(row);
    return 1;
  }

  async update(values: relationalStore.ValuesBucket, predicates?: relationalStore.RdbPredicates): Promise<number> {
    const rows = this.resolveRows(predicates);
    rows.forEach((row) => {
      Object.assign(row, values);
    });
    return rows.length;
  }

  async delete(predicates?: relationalStore.RdbPredicates): Promise<number> {
    const rows = this.resolveRows(predicates);
    const removed = rows.length;
    Object.keys(this.tables).forEach((key) => {
      this.tables[key] = this.tables[key].filter((row) => !rows.includes(row));
    });
    return removed;
  }

  async query(predicates: relationalStore.RdbPredicates): Promise<FakeResultSet> {
    const rows = this.resolveRows(predicates);
    return new FakeResultSet(rows.map((row) => ({ ...row })));
  }

  async querySql(sql: string): Promise<FakeResultSet> {
    if (!sql.includes('FROM visits INNER JOIN places')) {
      return new FakeResultSet([]);
    }
    const rows: Row[] = [];
    this.tables.visits.forEach((visit) => {
      const place = this.tables.places.find((item) => item.id === visit.placeId);
      if (!place) {
        return;
      }
      rows.push({
        visitId: visit.id,
        placeId: visit.placeId,
        visitedAt: visit.visitedAt ?? 0,
        note: visit.note ?? null,
        place_id: place.id,
        place_name: place.name,
        place_countryCode: place.countryCode ?? null,
        place_city: place.city ?? null,
        place_lat: place.lat ?? 0,
        place_lon: place.lon ?? 0
      });
    });
    return new FakeResultSet(rows);
  }

  private resolveRows(predicates?: relationalStore.RdbPredicates): Row[] {
    if (!predicates) {
      return [];
    }
    const predAny = predicates as unknown as {
      tableName?: string;
      tableNames?: string[];
      getTableName?: () => string;
    };
    const tableName =
      predAny.tableName ??
      predAny.tableNames?.[0] ??
      (typeof predAny.getTableName === 'function' ? predAny.getTableName() : undefined);
    if (!tableName || !this.tables[tableName]) {
      return [];
    }
    return this.tables[tableName];
  }
}

export class TestDatabase {
  private store = new FakeRdbStore() as unknown as relationalStore.RdbStore;

  getStore(): relationalStore.RdbStore {
    return this.store;
  }
}
