import { TracePage } from './Trace';
import { ExperiencePage } from './Experience';
import { AddPage } from './Add';
import { RemiPage } from './Remi';
import { ProfilePage } from './Profile';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0

  build() {
    Tabs({
      index: this.currentIndex,
      barPosition: BarPosition.End
    }) {
      TabContent() {
        TracePage()
      }.tabBar({ text: '足迹' })

      TabContent() {
        ExperiencePage()
      }.tabBar({ text: '经历' })

      TabContent() {
        AddPage()
      }.tabBar({ icon: $r('app.media.add_plus') })

      TabContent() {
        RemiPage()
      }.tabBar({ text: '回响' })

      TabContent() {
        ProfilePage()
      }.tabBar({ text: '我的' })
    }.onChange((index: number) => {
      this.currentIndex = index
    })
  }
}
