import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import type common from '@ohos.app.ability.common';

const LOCATION_PERMS = ['ohos.permission.LOCATION'];
const MEDIA_PERMS = ['ohos.permission.READ_MEDIA'];
const AUDIO_PERMS = ['ohos.permission.MICROPHONE'];

export interface PermissionResult {
  authResults: number[];
}

export interface PermissionManager {
  requestPermissionsFromUser(context: common.UIAbilityContext, permissions: string[]): Promise<PermissionResult>;
}

export class Permissions {
  private atManager: PermissionManager;

  constructor(manager?: PermissionManager) {
    // Avoid relying on AtManager type (it differs across SDKs and breaks ArkTS structural typing rules).
    // If no manager is provided (production), use abilityAccessCtrl.createAtManager() but cast through unknown.
    this.atManager = (manager ? manager : (abilityAccessCtrl.createAtManager() as unknown as PermissionManager));
  }

  async requestLocation(context: common.UIAbilityContext): Promise<boolean> {
    return this.requestPermissions(context, LOCATION_PERMS);
  }

  async requestMedia(context: common.UIAbilityContext): Promise<boolean> {
    return this.requestPermissions(context, MEDIA_PERMS);
  }

  async requestAudio(context: common.UIAbilityContext): Promise<boolean> {
    return this.requestPermissions(context, AUDIO_PERMS);
  }

  private async requestPermissions(
    context: common.UIAbilityContext,
    permissions: string[]
  ): Promise<boolean> {
    const result = await this.atManager.requestPermissionsFromUser(context, permissions);
    return result.authResults.every((auth) => auth === 0);
  }
}
