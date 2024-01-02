
import router from '@ohos.router';
import PermissionUtil from '../utils/PermissionUtil';
import PreferencesUtil from '../utils/PreferencesUtil';
import ListPage from './ListPage';
import TodoDialog from './TodoDialog';

@Preview
@Entry
@Component
export default struct MainPage{

  @State refresh : boolean = false
  dialogController: CustomDialogController = new CustomDialogController({
    builder: TodoDialog({
      confirm: ()=>{
        this.refresh = true
      }
    }),
    alignment: DialogAlignment.Bottom,
    offset: {dx: 0, dy: -20}
  })


  aboutToAppear(){
    // ohos.permission.PUBLISH_AGENT_REMINDER
    PermissionUtil.checkPermissions('ohos.permission.WRITE_CALENDAR')
      .then(value=>{

      }).catch(ex=>{
      PermissionUtil.reqPermissionsFromUser(['ohos.permission.WRITE_CALENDAR'])
        .then(value=>{
          if (!value[0]) {
            PermissionUtil.openPermissionsInSystemSettings()
          }
        })
    })
  }

  /**
   * 将待办事项写入日历
   */
  writeTodoInCalendar(){

  }

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

        ListPage({refresh : this.refresh}).width('100%')
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
      this.dialogController.open()
    } else {
      router.replaceUrl({url: 'pages/login/LoginPage'})
    }
  }

   checkIsLogin(){
    return AppStorage.SetAndProp("login", false).get()
  }
}