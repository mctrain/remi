import { RemiColors, RemiSpacing, RemiTypography } from '../common/ui/Tokens';
import { StatsService, StatsSummary } from '../services/stats';

@Component
export struct ProfilePage {
  @State stats: StatsSummary = { countries: 0, cities: 0, visits: 0 };

  aboutToAppear() {
    new StatsService().getSummary().then((summary) => {
      this.stats = summary;
    });
  }

  build() {
    Column() {
      // Header Section
      Column() {
        // Avatar Placeholder - stylized as a "planet" or "lens"
        Stack({ alignContent: Alignment.Center }) {
          Circle({ width: 88, height: 88 })
            .fill(RemiColors.Surface)
            .stroke(RemiColors.Primary)
            .strokeWidth(2)
          
          Text('R')
            .fontSize(32)
            .fontWeight(FontWeight.Bold)
            .fontColor(RemiColors.Primary)
        }
        .margin({ bottom: RemiSpacing.Medium })

        Text('Voyager')
          .fontSize(RemiTypography.H2)
          .fontWeight(RemiTypography.WeightBold)
          .fontColor(RemiColors.TextPrimary)
          .margin({ bottom: RemiSpacing.XS })

        Text('Where every mile becomes a memory')
          .fontSize(RemiTypography.Body)
          .fontColor(RemiColors.TextSecondary)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .padding({ top: RemiSpacing.XXLarge, bottom: RemiSpacing.XLarge })

      // Stats Row
      Row() {
        this.StatItem(this.stats.countries.toString(), 'Countries')
        Divider().vertical(true).height(24).color(RemiColors.Divider)
        this.StatItem(this.stats.cities.toString(), 'Cities')
        Divider().vertical(true).height(24).color(RemiColors.Divider)
        this.StatItem(this.stats.visits.toString(), 'Echoes')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .padding({ bottom: RemiSpacing.XLarge })

      // Settings / Menu List
      List() {
        ListItem() {
          this.MenuItem('My Passport', 'View your travel badges')
        }
        .margin({ bottom: RemiSpacing.Small })

        ListItem() {
          this.MenuItem('Sensory Database', 'Manage audio & scent tags')
        }
        .margin({ bottom: RemiSpacing.Small })

        ListItem() {
          this.MenuItem('Privacy & Data', 'Local storage settings')
        }
        .margin({ bottom: RemiSpacing.Small })
        
        ListItem() {
           this.MenuItem('About Remi', 'v0.1.0 Beta')
        }
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
  StatItem(value: string, label: string) {
    Column() {
      Text(value)
        .fontSize(24)
        .fontWeight(RemiTypography.WeightBold)
        .fontColor(RemiColors.Accent)
        .margin({ bottom: 4 })
      Text(label)
        .fontSize(RemiTypography.Caption)
        .fontColor(RemiColors.TextSecondary)
    }
  }

  @Builder
  MenuItem(title: string, subtitle: string) {
    Row() {
      Column() {
        Text(title)
          .fontSize(RemiTypography.Body)
          .fontWeight(RemiTypography.WeightMedium)
          .fontColor(RemiColors.TextPrimary)
          .margin({ bottom: 4 })
        Text(subtitle)
          .fontSize(RemiTypography.Caption)
          .fontColor(RemiColors.TextSecondary)
      }
      .alignItems(HorizontalAlign.Start)

      // Simple chevron arrow
      Text('>')
        .fontSize(24)
        .fontColor(RemiColors.SurfaceHighlight)
    }
    .width('100%')
    .padding(RemiSpacing.Medium)
    .backgroundColor(RemiColors.Surface)
    .borderRadius(12)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }
}

