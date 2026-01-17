import { describe, it, expect } from '@ohos/hypium';
import { VisitsRepository } from '../../main/ets/data/repositories/visits';
import { PlacesRepository } from '../../main/ets/data/repositories/places';
import { TestDatabase } from './fakes';

describe('visits repository', () => {
  it('supports basic CRUD with a single visit', 0, async () => {
    const db = new TestDatabase();
    const visitsRepo = new VisitsRepository(db);
    const visit = { id: 'visit-1', placeId: 'place-1', visitedAt: 1000, note: 'first' };

    await visitsRepo.create(visit);
    let visits = await visitsRepo.getAll();
    expect(visits.length).assertEqual(1);
    expect(visits[0].note).assertEqual('first');

    await visitsRepo.update({ ...visit, note: 'updated' });
    visits = await visitsRepo.getAll();
    expect(visits[0].note).assertEqual('updated');

    await visitsRepo.remove(visit.id);
    visits = await visitsRepo.getAll();
    expect(visits.length).assertEqual(0);
  });

  it('returns visit with place relation', 0, async () => {
    const db = new TestDatabase();
    const placesRepo = new PlacesRepository(db);
    const visitsRepo = new VisitsRepository(db);

    await placesRepo.upsert({
      id: 'place-1',
      name: 'Bund',
      countryCode: 'CN',
      city: 'Shanghai',
      lat: 31.24,
      lon: 121.49
    });
    await visitsRepo.create({
      id: 'visit-1',
      placeId: 'place-1',
      visitedAt: 1000,
      note: 'night walk'
    });

    const results = await visitsRepo.listWithPlaces();
    expect(results.length).assertEqual(1);
    expect(results[0].place.name).assertEqual('Bund');
  });
});
