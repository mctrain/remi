import { describe, it, expect } from '@ohos/hypium';
import type { Context, Permissions as AbilityPermission } from '@ohos.abilityAccessCtrl';
import { PermissionManager, PermissionResult, Permissions } from '../../main/ets/platform/permissions';

describe('permissions', () => {
  it('returns false when permission is denied', 0, async () => {
    class DenyManager extends PermissionManager {
      async requestPermissionsFromUser(context: Context, permissions: AbilityPermission[]): Promise<PermissionResult> {
        return new PermissionResult([1])
      }
    }


    const permissions = new Permissions(new DenyManager());
    class FakeContext {}
    const context = new FakeContext() as Context;

    const result = await permissions.requestLocation(context);
    expect(result).assertEqual(false);
  });
});
