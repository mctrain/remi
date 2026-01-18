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
    const [places, visits] = await Promise.all([
      this.placesRepo.getAll(),
      this.visitsRepo.getAll()
    ])

    const countries = new Set(
      places
        .map((place) => place.countryCode)
        .filter((value): value is string => typeof value === 'string' && value.length > 0)
    )

    const cities = new Set(
      places
        .map((place) => place.city)
        .filter((value): value is string => typeof value === 'string' && value.length > 0)
    )

    return {
      countries: countries.size,
      cities: cities.size,
      visits: visits.length
    }
  }
}

