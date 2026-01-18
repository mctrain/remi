import { describe, it, expect } from '@ohos/hypium';
import { StatsService } from '../../main/ets/services/stats';
import { TestDatabase } from '../data/fakes';
import { PlacesRepository } from '../../main/ets/data/repositories/places';
import { VisitsRepository } from '../../main/ets/data/repositories/visits';

describe('stats service', () => {
  it('returns counts derived from repositories', 0, async () => {
    const db = new TestDatabase();
    await db.open({} as common.UIAbilityContext);
    const placesRepo = new PlacesRepository(db);
    const visitsRepo = new VisitsRepository(db);
    const stats = new StatsService(placesRepo, visitsRepo);

    await placesRepo.upsert({
      id: 'place-1',
      name: 'Bund',
      countryCode: 'CN',
      city: 'Shanghai',
      lat: 31.24,
      lon: 121.49
    });

    await placesRepo.upsert({
      id: 'place-2',
      name: 'Lujiazui',
      countryCode: 'CN',
      city: 'Shanghai',
      lat: 31.23,
      lon: 121.51
    });

    await placesRepo.upsert({
      id: 'place-3',
      name: 'Ginza',
      countryCode: 'JP',
      city: 'Tokyo',
      lat: 35.67,
      lon: 139.76
    });

    await visitsRepo.create({
      id: 'visit-1',
      placeId: 'place-1',
      visitedAt: 1000,
      note: 'night walk'
    });

    await visitsRepo.create({
      id: 'visit-2',
      placeId: 'place-3',
      visitedAt: 2000,
      note: undefined
    });

    const summary = await stats.getSummary();
    expect(summary.countries).assertEqual(2);
    expect(summary.cities).assertEqual(2);
    expect(summary.visits).assertEqual(2);
  });
});

