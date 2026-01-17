import type { Visit, VisitWithPlace, Place } from '../schema';
import { database, Database } from '../db';
import relationalStore from '@ohos.data.relationalStore';

export class VisitsRepository {
  constructor(private readonly db: Database = database) {}

  async create(visit: Visit): Promise<void> {
    const store = this.requireStore();
    const values: relationalStore.ValuesBucket = {
      id: visit.id,
      placeId: visit.placeId,
      visitedAt: visit.visitedAt,
      note: visit.note ?? null
    };
    await store.insert('visits', values);
  }

  async update(visit: Visit): Promise<void> {
    const store = this.requireStore();
    const values: relationalStore.ValuesBucket = {
      placeId: visit.placeId,
      visitedAt: visit.visitedAt,
      note: visit.note ?? null
    };
    const predicates = new relationalStore.RdbPredicates('visits').equalTo('id', visit.id);
    await store.update(values, predicates);
  }

  async getById(id: string): Promise<Visit | undefined> {
    const store = this.requireStore();
    const predicates = new relationalStore.RdbPredicates('visits').equalTo('id', id);
    const resultSet = await store.query(predicates);
    try {
      if (resultSet.rowCount === 0) {
        return undefined;
      }
      resultSet.goToFirstRow();
      return this.mapVisit(resultSet);
    } finally {
      resultSet.close();
    }
  }

  async getAll(): Promise<Visit[]> {
    const store = this.requireStore();
    const predicates = new relationalStore.RdbPredicates('visits');
    const resultSet = await store.query(predicates);
    const visits: Visit[] = [];
    try {
      if (resultSet.rowCount === 0) {
        return visits;
      }
      resultSet.goToFirstRow();
      do {
        visits.push(this.mapVisit(resultSet));
      } while (resultSet.goToNextRow());
      return visits;
    } finally {
      resultSet.close();
    }
  }

  async getByPlace(placeId: string): Promise<Visit[]> {
    const store = this.requireStore();
    const predicates = new relationalStore.RdbPredicates('visits').equalTo('placeId', placeId);
    const resultSet = await store.query(predicates);
    const visits: Visit[] = [];
    try {
      if (resultSet.rowCount === 0) {
        return visits;
      }
      resultSet.goToFirstRow();
      do {
        visits.push(this.mapVisit(resultSet));
      } while (resultSet.goToNextRow());
      return visits;
    } finally {
      resultSet.close();
    }
  }

  async remove(id: string): Promise<void> {
    const store = this.requireStore();
    const predicates = new relationalStore.RdbPredicates('visits').equalTo('id', id);
    await store.delete(predicates);
  }

  async listWithPlaces(): Promise<VisitWithPlace[]> {
    const store = this.requireStore();
    const resultSet = await store.querySql(
      'SELECT visits.id AS visitId, visits.placeId AS placeId, visits.visitedAt AS visitedAt, visits.note AS note, ' +
      'places.id AS place_id, places.name AS place_name, places.countryCode AS place_countryCode, ' +
      'places.city AS place_city, places.lat AS place_lat, places.lon AS place_lon ' +
      'FROM visits INNER JOIN places ON visits.placeId = places.id'
    );
    const results: VisitWithPlace[] = [];
    try {
      if (resultSet.rowCount === 0) {
        return results;
      }
      resultSet.goToFirstRow();
      do {
        const visit: Visit = {
          id: resultSet.getString(resultSet.getColumnIndex('visitId')),
          placeId: resultSet.getString(resultSet.getColumnIndex('placeId')),
          visitedAt: resultSet.getLong(resultSet.getColumnIndex('visitedAt')),
          note: this.readOptionalString(resultSet, 'note')
        };
        const place: Place = {
          id: resultSet.getString(resultSet.getColumnIndex('place_id')),
          name: resultSet.getString(resultSet.getColumnIndex('place_name')),
          countryCode: this.readOptionalString(resultSet, 'place_countryCode'),
          city: this.readOptionalString(resultSet, 'place_city'),
          lat: resultSet.getDouble(resultSet.getColumnIndex('place_lat')),
          lon: resultSet.getDouble(resultSet.getColumnIndex('place_lon'))
        };
        results.push({ visit, place });
      } while (resultSet.goToNextRow());
      return results;
    } finally {
      resultSet.close();
    }
  }

  private mapVisit(resultSet: relationalStore.ResultSet): Visit {
    return {
      id: resultSet.getString(resultSet.getColumnIndex('id')),
      placeId: resultSet.getString(resultSet.getColumnIndex('placeId')),
      visitedAt: resultSet.getLong(resultSet.getColumnIndex('visitedAt')),
      note: this.readOptionalString(resultSet, 'note')
    };
  }

  private readOptionalString(resultSet: relationalStore.ResultSet, column: string): string | undefined {
    const index = resultSet.getColumnIndex(column);
    if (resultSet.isColumnNull(index)) {
      return undefined;
    }
    return resultSet.getString(index);
  }

  private requireStore(): relationalStore.RdbStore {
    const store = this.db.getStore();
    if (!store) {
      throw new Error('Database not opened. Call database.open(context) first.');
    }
    return store;
  }
}
