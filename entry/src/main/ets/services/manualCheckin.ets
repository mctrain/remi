import type { Place, Visit } from '../data/schema';
import { PlacesRepository } from '../data/repositories/places';
import { VisitsRepository } from '../data/repositories/visits';

export interface ManualCheckinInput {
  name: string;
  lat: number;
  lon: number;
  note?: string;
  countryCode?: string;
  city?: string;
}

export interface CheckinResult {
  place: Place;
  visit: Visit;
}

export class ManualCheckinService {
  private readonly placesRepo: PlacesRepository
  private readonly visitsRepo: VisitsRepository

  constructor(
    placesRepo: PlacesRepository = new PlacesRepository(),
    visitsRepo: VisitsRepository = new VisitsRepository()
  ) {
    this.placesRepo = placesRepo
    this.visitsRepo = visitsRepo
  }

  async createManual(input: ManualCheckinInput): Promise<CheckinResult> {
    const place: Place = {
      id: this.createId('place'),
      name: input.name,
      countryCode: input.countryCode,
      city: input.city,
      lat: input.lat,
      lon: input.lon
    };
    const visit: Visit = {
      id: this.createId('visit'),
      placeId: place.id,
      visitedAt: Date.now(),
      note: input.note
    };
    await this.placesRepo.upsert(place);
    await this.visitsRepo.create(visit);
    return { place, visit };
  }

  private createId(prefix: string): string {
    return `${prefix}-${Date.now()}-${Math.floor(Math.random() * 100000)}`;
  }
}
