import { RemiColors, RemiSpacing, RemiTypography } from '../common/ui/Tokens';
import { VisitsRepository } from '../data/repositories/visits';
import { VisitWithPlace } from '../data/schema';

@Component
export struct ExperiencePage {
  @State experiences: VisitWithPlace[] = [];

  aboutToAppear() {
    new VisitsRepository().listWithPlaces().then((data) => {
      this.experiences = data;
    });
  }

  build() {
    Column() {
      // Header
      Row() {
        Text('Experiences')
          .fontSize(RemiTypography.H1)
          .fontWeight(RemiTypography.WeightBold)
          .fontColor(RemiColors.TextPrimary)
      }
      .width('100%')
      .padding({ 
        left: RemiSpacing.Medium, 
        right: RemiSpacing.Medium, 
        top: RemiSpacing.Large, 
        bottom: RemiSpacing.Medium 
      })

      // List
      List() {
        ForEach(this.experiences, (item: VisitWithPlace) => {
          ListItem() {
            this.ExperienceCard(item)
          }
          .margin({ bottom: RemiSpacing.Medium })
        })
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: RemiSpacing.Medium, right: RemiSpacing.Medium })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(RemiColors.DeepBackground)
  }

  @Builder
  ExperienceCard(item: VisitWithPlace) {
    Column() {
      Row() {
        Text(new Date(item.visit.visitedAt).toDateString())
          .fontSize(RemiTypography.Caption)
          .fontColor(RemiColors.Primary)
          .fontWeight(RemiTypography.WeightBold)
          .margin({ bottom: RemiSpacing.XS })
      }
      .width('100%')

      Text(item.place.name)
        .fontSize(RemiTypography.H3)
        .fontColor(RemiColors.TextPrimary)
        .fontWeight(RemiTypography.WeightMedium)
        .margin({ bottom: RemiSpacing.XS })
      
      Row() {
        // Location Pin
        Text('Loc: ' + (item.place.city ? item.place.city + ', ' : '') + (item.place.countryCode || 'Unknown'))
          .fontSize(RemiTypography.Caption)
          .fontColor(RemiColors.TextSecondary)
      }
      .margin({ bottom: RemiSpacing.Medium })

      // Tags (Note)
      if (item.visit.note) {
        Row({ space: RemiSpacing.Small }) {
          Text('#' + item.visit.note)
            .fontSize(10)
            .fontColor(RemiColors.TextInverse)
            .backgroundColor(RemiColors.Primary)
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(12)
        }
      }
    }
    .width('100%')
    .padding(RemiSpacing.Medium)
    .backgroundColor(RemiColors.Surface)
    .borderRadius(16)
    .alignItems(HorizontalAlign.Start)
  }
}

