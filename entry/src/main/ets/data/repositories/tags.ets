import type { SensoryTag } from '../schema';
import { database, Database } from '../db';
import relationalStore from '@ohos.data.relationalStore';

export class TagsRepository {
  constructor(private readonly db: Database = database) {}

  async upsert(tag: SensoryTag): Promise<void> {
    const store = this.requireStore();
    const existing = await this.getById(tag.id);
    const values: relationalStore.ValuesBucket = {
      id: tag.id,
      label: tag.label,
      category: tag.category
    };
    if (existing) {
      const predicates = new relationalStore.RdbPredicates('tags').equalTo('id', tag.id);
      await store.update(values, predicates);
      return;
    }
    await store.insert('tags', values);
  }

  async getById(id: string): Promise<SensoryTag | undefined> {
    const store = this.requireStore();
    const predicates = new relationalStore.RdbPredicates('tags').equalTo('id', id);
    const resultSet = await store.query(predicates);
    try {
      if (resultSet.rowCount === 0) {
        return undefined;
      }
      resultSet.goToFirstRow();
      return this.mapTag(resultSet);
    } finally {
      resultSet.close();
    }
  }

  async getAll(): Promise<SensoryTag[]> {
    const store = this.requireStore();
    const predicates = new relationalStore.RdbPredicates('tags');
    const resultSet = await store.query(predicates);
    const tags: SensoryTag[] = [];
    try {
      if (resultSet.rowCount === 0) {
        return tags;
      }
      resultSet.goToFirstRow();
      do {
        tags.push(this.mapTag(resultSet));
      } while (resultSet.goToNextRow());
      return tags;
    } finally {
      resultSet.close();
    }
  }

  async listByCategory(category: SensoryTag['category']): Promise<SensoryTag[]> {
    const store = this.requireStore();
    const predicates = new relationalStore.RdbPredicates('tags').equalTo('category', category);
    const resultSet = await store.query(predicates);
    const tags: SensoryTag[] = [];
    try {
      if (resultSet.rowCount === 0) {
        return tags;
      }
      resultSet.goToFirstRow();
      do {
        tags.push(this.mapTag(resultSet));
      } while (resultSet.goToNextRow());
      return tags;
    } finally {
      resultSet.close();
    }
  }

  async remove(id: string): Promise<void> {
    const store = this.requireStore();
    const predicates = new relationalStore.RdbPredicates('tags').equalTo('id', id);
    await store.delete(predicates);
  }

  private mapTag(resultSet: relationalStore.ResultSet): SensoryTag {
    return {
      id: resultSet.getString(resultSet.getColumnIndex('id')),
      label: resultSet.getString(resultSet.getColumnIndex('label')),
      category: resultSet.getString(resultSet.getColumnIndex('category')) as SensoryTag['category']
    };
  }

  private requireStore(): relationalStore.RdbStore {
    const store = this.db.getStore();
    if (!store) {
      throw new Error('Database not opened. Call database.open(context) first.');
    }
    return store;
  }
}
