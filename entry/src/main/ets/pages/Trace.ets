import { RippleMap } from '../components/RippleMap';
import { RemiColors, RemiSpacing, RemiTypography } from '../common/ui/Tokens';

@Component
export struct TracePage {
  @State provider: 'osm' | 'huawei' = 'osm';

  build() {
    Column() {
      Row() {
        Text($r('app.string.trace_title'))
          .fontSize(RemiTypography.H3) // Was 20
          .fontWeight(FontWeight.Medium)
          .fontColor(RemiColors.TextPrimary);
        Row() {
          Button($r('app.string.trace_provider_osm'))
            .fontSize(12)
            .padding({ left: 10, right: 10, top: 6, bottom: 6 })
            .backgroundColor(this.provider === 'osm' ? RemiColors.SurfaceHighlight : RemiColors.Surface)
            .fontColor(RemiColors.TextPrimary)
            .onClick(() => {
              this.provider = 'osm';
            });
          Button($r('app.string.trace_provider_huawei'))
            .fontSize(12)
            .padding({ left: 10, right: 10, top: 6, bottom: 6 })
            .backgroundColor(this.provider === 'huawei' ? RemiColors.SurfaceHighlight : RemiColors.Surface)
            .fontColor(RemiColors.TextPrimary)
            .margin({ left: 8 })
            .onClick(() => {
              this.provider = 'huawei';
            });
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 8 })
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center);

      RippleMap({ provider: this.provider })
        .width('100%')
        .layoutWeight(1);
    }
    .width('100%')
    .height('100%')
    .backgroundColor(RemiColors.DeepBackground);
  }
}
