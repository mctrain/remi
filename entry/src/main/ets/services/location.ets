export interface LocationPoint {
  lat: number;
  lon: number;
  accuracy?: number;
}

export class LocationService {
  // TODO: integrate Location Kit
  getCurrent(): LocationPoint | null { return null; }
}
