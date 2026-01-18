export interface LocationPoint {
  lat: number;
  lon: number;
  accuracy?: number;
}

export interface LocationProvider {
  getCurrent(): Promise<LocationPoint>;
}

class SimulatedLocationProvider implements LocationProvider {
  async getCurrent(): Promise<LocationPoint> {
    return { lat: 31.2304, lon: 121.4737, accuracy: 1000 };
  }
}

export class LocationService {
  private readonly provider: LocationProvider

  constructor(provider: LocationProvider = new SimulatedLocationProvider()) {
    this.provider = provider
  }

  async getCurrent(): Promise<LocationPoint> {
    return this.provider.getCurrent();
  }
}
