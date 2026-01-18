import { LocationService } from '../services/location';
import { ManualCheckinService } from '../services/manualCheckin';
import { RemiColors, RemiSpacing, RemiTypography } from '../common/ui/Tokens';

@Component
export struct AddPage {
  @State nameInput: string = ''
  @State latInput: string = ''
  @State lonInput: string = ''
  @State noteInput: string = ''
  @State statusMessage: string = ''
  @State isSaving: boolean = false

  private readonly locationService: LocationService = new LocationService()
  private readonly manualService: ManualCheckinService = new ManualCheckinService()

  private parseCoordinate(value: string): number | null {
    const parsed = Number(value)
    if (!Number.isFinite(parsed)) {
      return null
    }
    return parsed
  }

  private async handleAutoCheckin(): Promise<void> {
    if (this.isSaving) {
      return
    }
    this.isSaving = true
    this.statusMessage = 'Locating...'
    try {
      const location = await this.locationService.getCurrent()
      await this.manualService.createManual({
        name: 'Current location',
        lat: location.lat,
        lon: location.lon,
        note: this.noteInput
      })
      this.statusMessage = 'Saved current location.'
    } catch {
      this.statusMessage = 'Failed to fetch location.'
    } finally {
      this.isSaving = false
    }
  }

  private async handleManualCheckin(): Promise<void> {
    if (this.isSaving) {
      return
    }
    const lat = this.parseCoordinate(this.latInput)
    const lon = this.parseCoordinate(this.lonInput)
    if (!this.nameInput.trim()) {
      this.statusMessage = 'Please enter a place name.'
      return
    }
    if (lat === null || lon === null) {
      this.statusMessage = 'Please enter valid coordinates.'
      return
    }
    this.isSaving = true
    this.statusMessage = 'Saving...'
    try {
      await this.manualService.createManual({
        name: this.nameInput.trim(),
        lat,
        lon,
        note: this.noteInput.trim() ? this.noteInput.trim() : undefined
      })
      this.statusMessage = 'Saved manual check-in.'
      this.nameInput = ''
      this.latInput = ''
      this.lonInput = ''
      this.noteInput = ''
    } catch {
      this.statusMessage = 'Failed to save check-in.'
    } finally {
      this.isSaving = false
    }
  }

  build() {
    Column() {
      Text('New Memory')
        .fontSize(RemiTypography.H1)
        .fontWeight(FontWeight.Bold)
        .fontColor(RemiColors.TextPrimary)
        .margin({ bottom: RemiSpacing.Large })

      // Auto Location Card
      Column() {
        Row() {
          Text('(@)')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(RemiColors.Primary)
          Text('Auto Location')
            .fontSize(RemiTypography.Body)
            .fontWeight(FontWeight.Medium)
            .fontColor(RemiColors.TextPrimary)
            .margin({ left: RemiSpacing.Small })
        }
        .width('100%')
        .margin({ bottom: RemiSpacing.Small })

        Text('Capture your current coordinates instantly.')
          .fontSize(RemiTypography.Caption)
          .fontColor(RemiColors.TextSecondary)
          .margin({ bottom: RemiSpacing.Medium })
        
        Button('Use Current Location')
          .onClick(async () => {
            await this.handleAutoCheckin()
          })
          .enabled(!this.isSaving)
          .backgroundColor(RemiColors.SurfaceHighlight)
          .fontColor(RemiColors.TextPrimary)
          .width('100%')
      }
      .width('100%')
      .padding(RemiSpacing.Medium)
      .backgroundColor(RemiColors.Surface)
      .borderRadius(16)
      .margin({ bottom: RemiSpacing.Large })

      // Manual Entry Section
      Text('Manual Entry')
        .fontSize(RemiTypography.H3)
        .fontWeight(FontWeight.Bold)
        .fontColor(RemiColors.TextPrimary)
        .margin({ bottom: RemiSpacing.Medium })
        .width('100%')

      TextInput({ text: this.nameInput, placeholder: 'Place name' })
        .onChange((value: string) => { this.nameInput = value })
        .placeholderColor(RemiColors.TextSecondary)
        .fontColor(RemiColors.TextPrimary)
        .backgroundColor(RemiColors.Surface)
        .borderRadius(8)
        .height(48)
        .margin({ bottom: RemiSpacing.Small })

      Row({ space: RemiSpacing.Small }) {
        TextInput({ text: this.latInput, placeholder: 'Lat' })
          .type(InputType.Number)
          .onChange((value: string) => { this.latInput = value })
          .placeholderColor(RemiColors.TextSecondary)
          .fontColor(RemiColors.TextPrimary)
          .backgroundColor(RemiColors.Surface)
          .borderRadius(8)
          .height(48)
          .layoutWeight(1)

        TextInput({ text: this.lonInput, placeholder: 'Lon' })
          .type(InputType.Number)
          .onChange((value: string) => { this.lonInput = value })
          .placeholderColor(RemiColors.TextSecondary)
          .fontColor(RemiColors.TextPrimary)
          .backgroundColor(RemiColors.Surface)
          .borderRadius(8)
          .height(48)
          .layoutWeight(1)
      }
      .width('100%')
      .margin({ bottom: RemiSpacing.Small })

      TextInput({ text: this.noteInput, placeholder: 'Add a note...' })
        .onChange((value: string) => { this.noteInput = value })
        .placeholderColor(RemiColors.TextSecondary)
        .fontColor(RemiColors.TextPrimary)
        .backgroundColor(RemiColors.Surface)
        .borderRadius(8)
        .height(48)
        .margin({ bottom: RemiSpacing.Large })

      Button('Save Check-in')
        .onClick(async () => {
          await this.handleManualCheckin()
        })
        .enabled(!this.isSaving)
        .backgroundColor(RemiColors.Primary)
        .fontColor(RemiColors.TextInverse)
        .width('100%')
        .height(56)

      if (this.statusMessage) {
        Text(this.statusMessage)
          .fontSize(RemiTypography.Caption)
          .fontColor(this.statusMessage.includes('Failed') ? RemiColors.Danger : RemiColors.Primary)
          .margin({ top: RemiSpacing.Medium })
      }
    }
    .width('100%')
    .height('100%')
    .padding(RemiSpacing.Medium)
    .backgroundColor(RemiColors.DeepBackground)
    .alignItems(HorizontalAlign.Start)
  }
}
