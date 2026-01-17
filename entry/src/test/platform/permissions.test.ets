import { describe, it, expect } from '@ohos/hypium';
import type common from '@ohos.app.ability.common';
import { Permissions } from '../../main/ets/platform/permissions';

describe('permissions', () => {
  it('returns false when permission is denied', 0, async () => {
    const manager = {
      async requestPermissionsFromUser() {
        return { authResults: [1] };
      }
    };
    const permissions = new Permissions(manager);
    const context = {} as common.UIAbilityContext;

    const result = await permissions.requestLocation(context);
    expect(result).assertEqual(false);
  });
});
