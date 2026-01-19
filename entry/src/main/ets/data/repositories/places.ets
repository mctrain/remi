import type { Place } from '../schema';
import { database, Database } from '../db';
import relationalStore from '@ohos.data.relationalStore';
import { Predicates, type ResultSet, type Store } from '../rdbTypes'

export class PlacesRepository {
  private readonly db: Database

  constructor(db: Database = database) {
    this.db = db
  }

  async upsert(place: Place): Promise<void> {
    const store = this.requireStore();
    const existing = await this.getById(place.id);
    const values: relationalStore.ValuesBucket = {
      id: place.id,
      name: place.name,
      countryCode: place.countryCode ?? null,
      city: place.city ?? null,
      lat: place.lat,
      lon: place.lon
    };
    if (existing) {
      const predicates = new Predicates('places').equalTo('id', place.id)
      await store.update('places', values, predicates);
      return;
    }
    await store.insert('places', values);
  }

  async getById(id: string): Promise<Place | undefined> {
    const store = this.requireStore();
    const predicates = new Predicates('places').equalTo('id', id)
    const resultSet = await store.query(predicates);
    try {
      if (resultSet.rowCount === 0) {
        return undefined;
      }
      resultSet.goToFirstRow();
      return this.mapPlace(resultSet);
    } finally {
      resultSet.close();
    }
  }

  async getAll(): Promise<Place[]> {
    const store = this.requireStore();
    const predicates = new Predicates('places')
    const resultSet = await store.query(predicates);
    const places: Place[] = [];
    try {
      if (resultSet.rowCount === 0) {
        return places;
      }
      resultSet.goToFirstRow();
      do {
        places.push(this.mapPlace(resultSet));
      } while (resultSet.goToNextRow());
      return places;
    } finally {
      resultSet.close();
    }
  }

  async remove(id: string): Promise<void> {
    const store = this.requireStore();
    const predicates = new Predicates('places').equalTo('id', id)
    await store.delete('places', predicates);
  }

  private mapPlace(resultSet: ResultSet): Place {
    return {
      id: resultSet.getString(resultSet.getColumnIndex('id')),
      name: resultSet.getString(resultSet.getColumnIndex('name')),
      countryCode: this.readOptionalString(resultSet, 'countryCode'),
      city: this.readOptionalString(resultSet, 'city'),
      lat: resultSet.getDouble(resultSet.getColumnIndex('lat')),
      lon: resultSet.getDouble(resultSet.getColumnIndex('lon'))
    };
  }

  private readOptionalString(resultSet: ResultSet, column: string): string | undefined {
    const index = resultSet.getColumnIndex(column);
    if (resultSet.isColumnNull(index)) {
      return undefined;
    }
    return resultSet.getString(index);
  }

  private requireStore(): Store {
    const store = this.db.getStoreWrapper();
    if (!store) {
      throw new Error('Database not opened. Call database.open(context) first.');
    }
    return store;
  }
}
