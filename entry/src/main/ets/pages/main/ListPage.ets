import promptAction from '@ohos.promptAction'
import Page from '../entity/Page'
import Resource from '../entity/Resource'
import TodoItem from '../entity/TodoItem'
import { httpGet, httpGetEntity, httpPostPromise } from '../utils/HttpUtil'
import { get,  } from '../http/HttpUtils'
import TodoDialog from './TodoDialog'

@Preview
@Component
export default struct ListPage {

  @State isRefreshing: boolean = false
  @Prop  @Watch('refreshPage')refresh : boolean
  @State todoList: Array<TodoItem> = []
  @State selectItem : TodoItem = null
  private pageIndex = 1
  dialogController: CustomDialogController = new CustomDialogController({
    builder: TodoDialog({
      todoItem: this.selectItem,
      confirm: ()=>{
        this.getData()
      }
    }),
    alignment: DialogAlignment.Bottom,
    offset: {dx: 0, dy: -20}
  })

  aboutToAppear() {
    this.getData()
  }

  refreshPage(){
    if (!this.refresh) {
      return
    }
    this.getData()
  }

  getData() {

    let url = `lg/todo/v2/list/${this.pageIndex}/json`

    get<Page<TodoItem>>(url).then((data: Page<TodoItem>) => {
      if (this.pageIndex == 1) {
        this.todoList = data.datas
        return
      }
      this.todoList.push(...data.datas)
    })

    // httpGetEntity<Page<TodoItem>>(url, (data: Page<TodoItem>) => {
    //   if (this.pageIndex == 1) {
    //     this.todoList = data.datas
    //     return
    //   }
    //   this.todoList.push(...data.datas)
    // }, error => {
    //
    // })
  }

  @Builder itemEnd(index: number) {
    // 侧滑后尾端出现的组件
    Image($r('app.media.ic_delete'))
      .width(26)
      .height(26)
    .onClick(() => {
      this.deleteTodo(index)
    })
  }

  build() {
    Column() {

      Refresh({ refreshing: $$this.isRefreshing, offset: 120, friction: 100 }) {
        List({space : 20}) {
          ForEach(this.todoList, (item: TodoItem, index) => {
            ListItem() {
              Row() {
                Checkbox()
                  .select(item.status == 1)
                  .margin({ right: 8 })

                Text(item.title)
              }.width('100%')
            }.onClick(ev=>{
              this.selectItem = this.todoList[index]
              this.dialogController.open()
            }).swipeAction({ end: this.itemEnd.bind(this, index)})
          })
        }.width('100%')
        .height('100%')
        .padding({ left: 12, right: 12 })
      }
      .onStateChange((refreshStatus: RefreshStatus) => {
        console.info('Refresh onStatueChange state is ' + refreshStatus)
      })
      .onRefreshing(() => {
        setTimeout(() => {
          this.isRefreshing = false
        }, 1000)
        console.log('onRefreshing test')
      })


    }.width('100%')
  }

  deleteTodo(index){

    httpPostPromise(`lg/todo/delete/${this.todoList[index].id}/json`, {})
      .then(data=>{
        promptAction.showToast({ message : "删除成功" })
        this.todoList.splice(index, 1);
      })
  }

}