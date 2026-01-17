import { describe, it, expect } from '@ohos/hypium';
import { StatsService } from '../../main/ets/services/stats';

describe('stats service', () => {
  it('returns zero summary by default', 0, () => {
    const stats = new StatsService();
    const summary = stats.getSummary();
    expect(summary.visits).assertEqual(0);
  });
});
