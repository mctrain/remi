import { describe, it, expect } from '@ohos/hypium';
import { LocationService, LocationProvider, LocationPoint } from '../../main/ets/services/location';

class FakeLocationProvider implements LocationProvider {
  async getCurrent(): Promise<LocationPoint> {
    return { lat: 10.5, lon: 20.25, accuracy: 5 };
  }
}

describe('location service', () => {
  it('returns valid coordinates from provider', 0, async () => {
    const service = new LocationService(new FakeLocationProvider());
    const location = await service.getCurrent();
    expect(location.lat).assertEqual(10.5);
    expect(location.lon).assertEqual(20.25);
  });
});
