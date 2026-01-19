import type { Achievement } from '../schema';
import { database, Database } from '../db';
import relationalStore from '@ohos.data.relationalStore';
import { Predicates, type ResultSet, type Store } from '../rdbTypes'

export class AchievementsRepository {
  constructor(private readonly db: Database = database) {}

  async upsert(achievement: Achievement): Promise<void> {
    const store = this.requireStore();
    const existing = await this.getById(achievement.id);
    const values: relationalStore.ValuesBucket = {
      id: achievement.id,
      name: achievement.name,
      unlockedAt: achievement.unlockedAt ?? null
    };
    if (existing) {
       const predicates = new Predicates('achievements').equalTo('id', achievement.id)
       await store.update('achievements', values, predicates);

      return;
    }
    await store.insert('achievements', values);
  }

  async getById(id: string): Promise<Achievement | undefined> {
    const store = this.requireStore();
    const predicates = new Predicates('achievements').equalTo('id', id)
    const resultSet = await store.query(predicates);
    try {
      if (resultSet.rowCount === 0) {
        return undefined;
      }
      resultSet.goToFirstRow();
      return this.mapAchievement(resultSet);
    } finally {
      resultSet.close();
    }
  }

  async getAll(): Promise<Achievement[]> {
    const store = this.requireStore();
    const predicates = new Predicates('achievements')
    const resultSet = await store.query(predicates);
    const achievements: Achievement[] = [];
    try {
      if (resultSet.rowCount === 0) {
        return achievements;
      }
      resultSet.goToFirstRow();
      do {
        achievements.push(this.mapAchievement(resultSet));
      } while (resultSet.goToNextRow());
      return achievements;
    } finally {
      resultSet.close();
    }
  }

  async remove(id: string): Promise<void> {
    const store = this.requireStore();
    const predicates = new Predicates('achievements').equalTo('id', id)
    await store.delete('achievements', predicates);
  }

  private mapAchievement(resultSet: ResultSet): Achievement {
    return {
      id: resultSet.getString(resultSet.getColumnIndex('id')),
      name: resultSet.getString(resultSet.getColumnIndex('name')),
      unlockedAt: this.readOptionalLong(resultSet, 'unlockedAt')
    };
  }

  private readOptionalLong(resultSet: ResultSet, column: string): number | undefined {
    const index = resultSet.getColumnIndex(column);
    if (resultSet.isColumnNull(index)) {
      return undefined;
    }
    return resultSet.getLong(index);
  }

  private requireStore(): Store {
    const store = this.db.getStoreWrapper();
    if (!store) {
      throw new Error('Database not opened. Call database.open(context) first.');
    }
    return store;
  }
}
