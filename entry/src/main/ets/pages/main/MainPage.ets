
import router from '@ohos.router';
import PreferencesUtil from '../utils/PreferencesUtil';
import ListPage from './ListPage';
@Entry
@Component
export default struct MainPage{

  private arr: number[] = [1, 2, 3];

  build() {
    Stack({ alignContent: Alignment.Bottom }){
      Column() {
        Row(){
          Text("待办")
            .fontSize(32)
            .margin({ top:24, left: 24 })

        }.justifyContent(FlexAlign.Start)
        .width('100%')
        TextInput({ placeholder: 'search...' })
          .margin(12)
          .height(45)

        ListPage()
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')

      Image($r('app.media.add'))
        .width(42)
        .height(42)
        .padding(6)
        .margin({bottom: 50})
        .clip(new Circle({ width: 42, height: 42 }))
        .backgroundColor($r('app.color.blue'))
        .shadow({ radius: 5 })
        .onClick(ev=>{
          this.goToAddPage()
        })

    }.height('100%')
    .width('100%')
  }

  goToAddPage(){
    if(this.checkIsLogin()){
      router.pushUrl({url: 'pages/detail/DetailPage'})
    } else {
      router.pushUrl({url: 'pages/login/LoginPage'})
    }
  }

   checkIsLogin(){
    return AppStorage.SetAndProp("login", false).get()
  }
}