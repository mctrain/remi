import { TracePage } from './Trace';
import { ExperiencePage } from './Experience';
import { AddPage } from './Add';
import { RemiPage } from './Remi';
import { ProfilePage } from './Profile';

@Entry
@Component
struct Index {
  build() {
    // TODO: replace with real tabs/router
    Column() {
      Text('Remi')
      TracePage()
      ExperiencePage()
      AddPage()
      RemiPage()
      ProfilePage()
    }
  }
}
