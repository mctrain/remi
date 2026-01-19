import { describe, it, expect } from '@ohos/hypium';
import { EchoService } from '../../main/ets/services/echo';
import { TestDatabase } from '../data/fakes';
import { PlacesRepository } from '../../main/ets/data/repositories/places';
import { VisitsRepository } from '../../main/ets/data/repositories/visits';

describe('echo service', () => {
  it('returns visits that match month/day of provided date', 0, async () => {
    const db = new TestDatabase();
    const placesRepo = new PlacesRepository(db);
    const visitsRepo = new VisitsRepository(db);
    const echo = new EchoService(visitsRepo);

    await placesRepo.upsert({
      id: 'place-1',
      name: 'Bund',
      countryCode: 'CN',
      city: 'Shanghai',
      lat: 31.24,
      lon: 121.49
    });

    const matchDate = new Date(2025, 0, 18, 12, 0, 0); // Jan 18
    const otherDate = new Date(2025, 0, 19, 12, 0, 0); // Jan 19

    await visitsRepo.create({
      id: 'visit-1',
      placeId: 'place-1',
      visitedAt: matchDate.getTime(),
      note: 'morning coffee'
    });

    await visitsRepo.create({
      id: 'visit-2',
      placeId: 'place-1',
      visitedAt: otherDate.getTime(),
      note: 'different day'
    });

    const results = await echo.listOnThisDay(matchDate.getTime());
    expect(results.length).assertEqual(1);
    expect(results[0].place.name).assertEqual('Bund');
    expect(results[0].visit.id).assertEqual('visit-1');
  });
});
