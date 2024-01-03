import promptAction from '@ohos.promptAction'
import Page from '../entity/Page'
import TodoItem from '../entity/TodoItem'
import { get, post, postForm, } from '../http/HttpUtils'
import TodoDialog from './TodoDialog'
import CommonDialog from '../utils/CommonDialog'

@Preview
@Component
export default struct ListPage {
  @State isRefreshing: boolean = false
  @Prop @Watch('refreshPage') refresh: boolean
  @State todoList: Array<TodoItem> = []
  @State selectItem: TodoItem = null
  private pageIndex = 1
  dialogController: CustomDialogController = new CustomDialogController({
    builder: TodoDialog({
      todoItem: this.selectItem,
      confirm: () => {
        this.getData()
      }
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 }
  })

  aboutToAppear() {
    this.getData()
  }

  refreshPage() {
    if (!this.refresh) {
      return
    }
    this.getData()
  }

  getData() {

    let url = `lg/todo/v2/list/${this.pageIndex}/json?orderby=1`

    console.info("getData")
    get<Page<TodoItem>>(url).then((data: Page<TodoItem>) => {
      AppStorage.SetOrCreate("login", true)
      this.isRefreshing = false
      if (this.pageIndex == 1) {
        this.todoList = data.datas
        return
      }
      this.todoList.push(...data.datas)
    }).catch(err => {
      promptAction.showToast({ message: err })
    })

  }

  @Builder itemEnd(index: number) {
    // 侧滑后尾端出现的组件
    Image($r('app.media.ic_delete'))
      .width(26)
      .height(26)
      .onClick(() => {
        CommonDialog.openDoubleDialog("提示", "确认删除该项？", { text: "确认", onClick: () => {
          this.deleteTodo(index)
        } }, { text: "取消",})
      })
  }

  build() {
    Column() {

      Refresh({ refreshing: $$this.isRefreshing, offset: 120, friction: 100 }) {
        List({ space: 20 }) {
          ForEach(this.todoList, (item: TodoItem, index) => {
            ListItem() {
              Row() {
                Checkbox()
                  .select(item.status == 1)
                  .margin({ right: 8 })
                  .onChange(value=>{
                    this.updateTodoState(item)
                  })

                Text(item.title)
                  .decoration({
                    type: item.status == 1 ? TextDecorationType.LineThrough : TextDecorationType.None,
                  })
              }.width('100%')
            }.onClick(ev => {
              this.selectItem = this.todoList[index]
              this.dialogController.open()
            }).swipeAction({ end: this.itemEnd.bind(this, index) })
          })
        }.width('100%')
        .height('100%')
        .padding({ left: 12, right: 12 })
      }
      .onStateChange((refreshStatus: RefreshStatus) => {
        console.info('Refresh onStatueChange state is ' + refreshStatus)
      })
      .onRefreshing(() => {
        this.getData()
      })

    }.width('100%')
  }

  deleteTodo(index) {

    post(`lg/todo/delete/${this.todoList[index].id}/json`, {})
      .then(data => {
        promptAction.showToast({ message: "删除成功" })
        this.todoList.splice(index, 1);
      })
  }

  updateTodoState(item : TodoItem){
    postForm(`lg/todo/done/${item.id}/json`, `status=${item.status === 0? 1 : 0}`)
      .then(data => {
        this.getData()
      })
  }
}