import { describe, it, expect } from '@ohos/hypium';
import { VisitsRepository } from '../../main/ets/data/repositories/visits';

describe('visits repository', () => {
  it('returns empty list by default', 0, () => {
    const repo = new VisitsRepository();
    expect(repo.getAll().length).assertEqual(0);
  });
});
