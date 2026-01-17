import { RippleMap } from '../components/RippleMap';

@Component
export struct TracePage {
  @State provider: 'osm' | 'huawei' = 'osm';

  build() {
    Column() {
      Row() {
        Text('足迹')
          .fontSize(20)
          .fontWeight(FontWeight.Medium);
        Row() {
          Button('OpenStreetMap')
            .fontSize(12)
            .padding({ left: 10, right: 10, top: 6, bottom: 6 })
            .backgroundColor(this.provider === 'osm' ? '#2B4A5F' : '#162531')
            .fontColor('#E8F3FF')
            .onClick(() => {
              this.provider = 'osm';
            });
          Button('Huawei Map')
            .fontSize(12)
            .padding({ left: 10, right: 10, top: 6, bottom: 6 })
            .backgroundColor(this.provider === 'huawei' ? '#2B4A5F' : '#162531')
            .fontColor('#E8F3FF')
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
    .backgroundColor('#0F1C28');
  }
}
