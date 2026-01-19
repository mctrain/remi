import type { MediaItem } from '../schema';
import { database, Database } from '../db';
import relationalStore from '@ohos.data.relationalStore';
import { Predicates, type ResultSet, type Store } from '../rdbTypes'

export class MediaRepository {
  constructor(private readonly db: Database = database) {}

  async add(item: MediaItem): Promise<void> {
    const store = this.requireStore();
    const values: relationalStore.ValuesBucket = {
      id: item.id,
      visitId: item.visitId,
      uri: item.uri,
      type: item.type
    };
    await store.insert('media', values);
  }

  async getByVisit(visitId: string): Promise<MediaItem[]> {
    const store = this.requireStore();
    const predicates = new Predicates('media').equalTo('visitId', visitId)
    const resultSet = await store.query(predicates);
    const items: MediaItem[] = [];
    try {
      if (resultSet.rowCount === 0) {
        return items;
      }
      resultSet.goToFirstRow();
      do {
        items.push(this.mapItem(resultSet));
      } while (resultSet.goToNextRow());
      return items;
    } finally {
      resultSet.close();
    }
  }

  async remove(id: string): Promise<void> {
    const store = this.requireStore();
    const predicates = new Predicates('media').equalTo('id', id)
    await store.delete('media', predicates);
  }

  private mapItem(resultSet: ResultSet): MediaItem {
    return {
      id: resultSet.getString(resultSet.getColumnIndex('id')),
      visitId: resultSet.getString(resultSet.getColumnIndex('visitId')),
      uri: resultSet.getString(resultSet.getColumnIndex('uri')),
      type: resultSet.getString(resultSet.getColumnIndex('type')) as MediaItem['type']
    };
  }

  private requireStore(): Store {
    const store = this.db.getStoreWrapper();
    if (!store) {
      throw new Error('Database not opened. Call database.open(context) first.');
    }
    return store;
  }
}
