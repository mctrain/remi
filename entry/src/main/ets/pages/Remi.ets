import { RemiColors, RemiSpacing, RemiTypography } from '../common/ui/Tokens';
import { EchoService } from '../services/echo';

@Component
export struct RemiPage {
  @State memory: string = 'Listening for echoes...';
  @State hasMemory: boolean = false;

  aboutToAppear() {
    new EchoService().getOnThisDay(Date.now()).then((memories) => {
      if (memories && memories.length > 0) {
        this.memory = memories.join('\n\n');
        this.hasMemory = true;
      } else {
          this.memory = 'No echoes from the past found for today. Time to create new ones!';
        this.hasMemory = false;
      }
    });
  }

  build() {
    Column() {
      // Header
      Row() {
        Text($r('app.string.remi_title'))
          .fontSize(RemiTypography.H1)
          .fontWeight(RemiTypography.WeightBold)
          .fontColor(RemiColors.TextPrimary)
      }
      .width('100%')
      .padding({ 
        left: RemiSpacing.Medium, 
        right: RemiSpacing.Medium, 
        top: RemiSpacing.Large 
      })

      // Main Content - Centered
      Column() {
        // The Echo Visual
        Stack({ alignContent: Alignment.Center }) {
          // Outer ripple
          Circle({ width: 240, height: 240 })
            .fill(RemiColors.Surface)
            .opacity(0.3)
          
          // Inner ripple
          Circle({ width: 180, height: 180 })
            .fill(RemiColors.Surface)
            .opacity(0.5)
            
          // Core
          Circle({ width: 120, height: 120 })
            .fill(RemiColors.SurfaceHighlight)
            
          Text('*')
            .fontSize(64)
            .fontColor(RemiColors.Accent)
            .padding({ bottom: 12 }) // Adjust alignment for asterisk
        }
        .margin({ bottom: RemiSpacing.XLarge })

        Text($r('app.string.remi_prompt'))
          .fontSize(RemiTypography.H2)
          .fontWeight(RemiTypography.WeightMedium)
          .fontColor(RemiColors.TextPrimary)
          .margin({ bottom: RemiSpacing.Medium })

        Text(this.memory)
          .fontSize(RemiTypography.Body)
          .fontColor(RemiColors.TextSecondary)
          .textAlign(TextAlign.Center)
          .padding({ left: RemiSpacing.XLarge, right: RemiSpacing.XLarge })
          .lineHeight(24)
          
        Button(this.hasMemory ? 'View Memory' : 'Start Journey')
          .backgroundColor(RemiColors.Primary)
          .fontColor(RemiColors.TextInverse)
          .margin({ top: RemiSpacing.XLarge })
          .width('60%')
          .height(48)
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(RemiColors.DeepBackground)
  }
}

