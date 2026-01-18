import { TracePage } from './Trace';
import { ExperiencePage } from './Experience';
import { AddPage } from './Add';
import { RemiPage } from './Remi';
import { ProfilePage } from './Profile';
import { RemiColors, RemiSpacing } from '../common/ui/Tokens';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0

  @Builder
  private tabBarItem(index: number, label: string, icon: Resource, activeIcon: Resource): void {
    Column() {
      Divider()
        .strokeWidth(0.5)
        .color(RemiColors.Divider)
        .width('100%')
        .margin({ bottom: 4 })
      Image(this.currentIndex === index ? activeIcon : icon)
        .width(22)
        .height(22)
        .fillColor(this.currentIndex === index ? RemiColors.Primary : RemiColors.TextSecondary)
      Text(label)
        .fontSize(10)
        .fontColor(this.currentIndex === index ? RemiColors.Primary : RemiColors.TextSecondary)
        .margin({ top: 2 })
    }
    .width('100%')
    .padding({ top: 6, bottom: 6 })
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(RemiColors.DeepBackground)
  }

  @Builder
  private tabBarTrace(): void {
    this.tabBarItem(0, 'Trace', $r('app.media.tab_trace'), $r('app.media.tab_trace_active'))
  }

  @Builder
  private tabBarExperience(): void {
    this.tabBarItem(1, 'Journal', $r('app.media.tab_experience'), $r('app.media.tab_experience_active'))
  }

  @Builder
  private tabBarAdd(): void {
    this.tabBarItem(2, 'Capture', $r('app.media.tab_add'), $r('app.media.tab_add_active'))
  }

  @Builder
  private tabBarRemi(): void {
    this.tabBarItem(3, 'Echo', $r('app.media.tab_remi'), $r('app.media.tab_remi_active'))
  }

  @Builder
  private tabBarProfile(): void {
    this.tabBarItem(4, 'Profile', $r('app.media.tab_profile'), $r('app.media.tab_profile_active'))
  }

  build() {
    Tabs({
      index: this.currentIndex,
      barPosition: BarPosition.End
    }) {
      TabContent() {
        TracePage()
      }.tabBar(this.tabBarTrace)

      TabContent() {
        ExperiencePage()
      }.tabBar(this.tabBarExperience)

      TabContent() {
        AddPage()
      }.tabBar(this.tabBarAdd)

      TabContent() {
        RemiPage()
      }.tabBar(this.tabBarRemi)

      TabContent() {
        ProfilePage()
      }.tabBar(this.tabBarProfile)
    }.onChange((index: number) => {
      this.currentIndex = index
    })
  }
}
