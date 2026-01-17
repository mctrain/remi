import web_webview from '@ohos.web.webview';

interface RipplePoint {
  id: string;
  x: number;
  y: number;
}

@Component
export struct RippleMap {
  @Prop provider: 'osm' | 'huawei' = 'osm';
  private points: RipplePoint[] = [
    { id: 'shanghai', x: 0.62, y: 0.38 },
    { id: 'paris', x: 0.38, y: 0.28 },
    { id: 'tokyo', x: 0.76, y: 0.34 }
  ];
  private controller: web_webview.WebviewController = new web_webview.WebviewController();
  @State mapWidth: number = 320;
  @State mapHeight: number = 560;
  @State pulseA: boolean = false;
  @State pulseB: boolean = false;
  private timerId?: number;

  aboutToAppear(): void {
    this.timerId = setInterval(() => {
      this.pulseA = !this.pulseA;
      this.pulseB = !this.pulseB;
    }, 1600) as number;
  }

  aboutToDisappear(): void {
    if (this.timerId !== undefined) {
      clearInterval(this.timerId);
      this.timerId = undefined;
    }
  }

  build() {
    Stack() {
      if (this.provider === 'osm') {
        Web({ src: $rawfile('osm/index.html'), controller: this.controller })
          .width('100%')
          .height('100%')
          .javaScriptAccess(true)
          .domStorageAccess(true);
      } else {
        Column() {
          Text('Huawei Map Kit')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#E8F3FF');
          Text('Not configured yet. Add Map Kit to enable.')
            .fontSize(12)
            .fontColor('#7AA0B8')
            .margin({ top: 6 });
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor('#0F1C28');
      }

      ForEach(this.points, (point: RipplePoint) => {
        Stack() {
          Text('')
            .width(40)
            .height(40)
            .borderRadius(20)
            .border({ width: 1.5, color: '#7FD3FF' })
            .opacity(0.35)
            .scale({ x: this.pulseA ? 1.25 : 0.9, y: this.pulseA ? 1.25 : 0.9 })
            .animation({ duration: 1600, curve: Curve.EaseOut });
          Text('')
            .width(22)
            .height(22)
            .borderRadius(11)
            .border({ width: 1.5, color: '#7FD3FF' })
            .opacity(0.55)
            .scale({ x: this.pulseB ? 1.1 : 0.85, y: this.pulseB ? 1.1 : 0.85 })
            .animation({ duration: 1600, curve: Curve.EaseOut });
          Text('')
            .width(8)
            .height(8)
            .borderRadius(4)
            .backgroundColor('#7FD3FF');
        }
        .width(40)
        .height(40)
        .offset({
          x: point.x * this.mapWidth - 20,
          y: point.y * this.mapHeight - 20
        });
      }, (point: RipplePoint) => point.id);
    }
    .width('100%')
    .height('100%')
    .onAreaChange((oldValue: Area, newValue: Area) => {
      const width = Number.parseFloat(String(newValue.width));
      const height = Number.parseFloat(String(newValue.height));
      this.mapWidth = Number.isFinite(width) ? width : this.mapWidth;
      this.mapHeight = Number.isFinite(height) ? height : this.mapHeight;
    })
    .backgroundColor('#0F1C28');
  }
}
