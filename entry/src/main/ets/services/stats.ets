import { PlacesRepository } from '../data/repositories/places';
import { VisitsRepository } from '../data/repositories/visits';

export interface StatsSummary {
  countries: number;
  cities: number;
  visits: number;
}

export class StatsService {
  private readonly placesRepo: PlacesRepository
  private readonly visitsRepo: VisitsRepository

  constructor(
    placesRepo: PlacesRepository = new PlacesRepository(),
    visitsRepo: VisitsRepository = new VisitsRepository()
  ) {
    this.placesRepo = placesRepo
    this.visitsRepo = visitsRepo
  }

  async getSummary(): Promise<StatsSummary> {
    const placesPromise = this.placesRepo.getAll()
    const visitsPromise = this.visitsRepo.getAll()

    const places = await placesPromise
    const visits = await visitsPromise

    const countriesSet = new Set<string>()
    const citiesSet = new Set<string>()

    for (const place of places) {
      const countryCode = place.countryCode
      if (typeof countryCode === 'string' && countryCode.length > 0) {
        countriesSet.add(countryCode)
      }

      const city = place.city
      if (typeof city === 'string' && city.length > 0) {
        citiesSet.add(city)
      }
    }

    return {
      countries: countriesSet.size,
      cities: citiesSet.size,
      visits: visits.length
    }
  }
}

