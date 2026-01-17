import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import type common from '@ohos.app.ability.common';

const LOCATION_PERMS = ['ohos.permission.LOCATION'];
const MEDIA_PERMS = ['ohos.permission.READ_MEDIA'];
const AUDIO_PERMS = ['ohos.permission.MICROPHONE'];

type PermissionManager = {
  requestPermissionsFromUser: (context: common.UIAbilityContext, permissions: string[]) => Promise<{
    authResults: number[];
  }>;
};

export class Permissions {
  private atManager: PermissionManager;

  constructor(manager: PermissionManager = abilityAccessCtrl.createAtManager()) {
    this.atManager = manager;
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
