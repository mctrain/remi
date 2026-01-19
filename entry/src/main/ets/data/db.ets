import relationalStore from '@ohos.data.relationalStore';
import type common from '@ohos.app.ability.common';
import { SystemStore, type Store } from './rdbTypes'

const DB_NAME = 'remi.db';

export class Database {
  protected store?: relationalStore.RdbStore;

  async open(context: common.UIAbilityContext): Promise<void> {
    if (this.store) {
      return;
    }
    const config: relationalStore.StoreConfig = {
      name: DB_NAME,
      securityLevel: relationalStore.SecurityLevel.S1
    };
    this.store = await relationalStore.getRdbStore(context, config);
    await this.createTables();
  }

  getStoreWrapper(): Store | undefined {
    if (!this.store) {
      return undefined
    }
    return new SystemStore(this.store)
  }

  async close(): Promise<void> {
    if (!this.store) {
      return;
    }
    await this.store.close();
    this.store = undefined;
  }

  protected async createTables(): Promise<void> {
    if (!this.store) {
      return;
    }
    await this.store.executeSql(
      'CREATE TABLE IF NOT EXISTS places (' +
      'id TEXT PRIMARY KEY, ' +
      'name TEXT NOT NULL, ' +
      'countryCode TEXT, ' +
      'city TEXT, ' +
      'lat REAL NOT NULL, ' +
      'lon REAL NOT NULL' +
      ')'
    );
    await this.store.executeSql(
      'CREATE TABLE IF NOT EXISTS visits (' +
      'id TEXT PRIMARY KEY, ' +
      'placeId TEXT NOT NULL, ' +
      'visitedAt INTEGER NOT NULL, ' +
      'note TEXT' +
      ')'
    );
    await this.store.executeSql(
      'CREATE TABLE IF NOT EXISTS media (' +
      'id TEXT PRIMARY KEY, ' +
      'visitId TEXT NOT NULL, ' +
      'uri TEXT NOT NULL, ' +
      'type TEXT NOT NULL' +
      ')'
    );
    await this.store.executeSql(
      'CREATE TABLE IF NOT EXISTS tags (' +
      'id TEXT PRIMARY KEY, ' +
      'label TEXT NOT NULL, ' +
      'category TEXT NOT NULL' +
      ')'
    );
    await this.store.executeSql(
      'CREATE TABLE IF NOT EXISTS achievements (' +
      'id TEXT PRIMARY KEY, ' +
      'name TEXT NOT NULL, ' +
      'unlockedAt INTEGER' +
      ')'
    );
    await this.store.executeSql('CREATE INDEX IF NOT EXISTS idx_visits_place ON visits(placeId)');
  }
}

export const database = new Database();
