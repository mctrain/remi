import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import type { Context, Permissions as AbilityPermission } from '@ohos.abilityAccessCtrl';

export abstract class PermissionManager {
  abstract requestPermissionsFromUser(context: Context, permissions: AbilityPermission[]): Promise<PermissionResult>
}

const LOCATION_PERMS: AbilityPermission[] = ['ohos.permission.LOCATION'];
const MEDIA_PERMS: AbilityPermission[] = ['ohos.permission.READ_MEDIA'];
const AUDIO_PERMS: AbilityPermission[] = ['ohos.permission.MICROPHONE'];

export class PermissionResult {
  authResults: number[]

  constructor(authResults: number[]) {
    this.authResults = authResults
  }
}


export class Permissions {
  private atManager: PermissionManager

  constructor(manager: PermissionManager) {
    this.atManager = manager
  }

  static createDefault(): Permissions {
    class AtManagerAdapter extends PermissionManager {
      private readonly atManager: abilityAccessCtrl.AtManager

      constructor(atManager: abilityAccessCtrl.AtManager) {
        super()
        this.atManager = atManager
      }

      async requestPermissionsFromUser(context: Context, permissions: AbilityPermission[]): Promise<PermissionResult> {
        const result = await this.atManager.requestPermissionsFromUser(context, permissions)
        return new PermissionResult(result.authResults)
      }
    }

    return new Permissions(new AtManagerAdapter(abilityAccessCtrl.createAtManager()))
  }

  async requestLocation(context: Context): Promise<boolean> {
    return this.requestPermissions(context, LOCATION_PERMS);
  }

  async requestMedia(context: Context): Promise<boolean> {
    return this.requestPermissions(context, MEDIA_PERMS);
  }

  async requestAudio(context: Context): Promise<boolean> {
    return this.requestPermissions(context, AUDIO_PERMS);
  }

  private async requestPermissions(
    context: Context,
    permissions: AbilityPermission[]
  ): Promise<boolean> {
    const result = await this.atManager.requestPermissionsFromUser(context, permissions);
    return result.authResults.every((auth) => auth === 0);
  }
}
