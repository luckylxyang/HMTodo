import promptAction from '@ohos.promptAction'
import TodoItem from '../entity/TodoItem'
import { post, postForm } from '../http/HttpUtils'
import { dateFormat } from '../utils/CommonUtils'
import { httpPost, httpPostFormPromise, httpPostPromise } from '../utils/HttpUtil'
import PermissionUtil from '../utils/PermissionUtil'
import Reminder from '../utils/ReminderAgentUtil'

@Preview
@CustomDialog
export default struct TodoDialog {
  @State timeReminder: string = ""
  controller: CustomDialogController
  @State todoItem: TodoItem = new TodoItem({})
  selectTime: Date = new Date()
  cancel: () => void
  confirm: () => void

  aboutToAppear(){
    if (this.todoItem.dateStr) {
      this.selectTime = new Date(this.todoItem.dateStr)
      this.timeReminder = this.todoItem.dateStr
    }
  }

  build() {
    Column() {
      TextInput({ text: this.todoItem.title, placeholder: '请输入标题' })
        .border({
          radius: 10,
        })
        .onChange(value => {
          this.todoItem.title = value
        })

      TextArea({ text: this.todoItem.content, placeholder: '请输入详情' })
        .height(65)
        .margin({ top: 15, bottom: 15 })
        .border({
          radius: 10,
        })
        .onChange(value => {
          this.todoItem.content = value
        })

      Row() {

        Row() {
          Image($r('app.media.ic_alarm_clock'))
            .width(20)
            .height(20)
            .margin({ right: 3 })
          Text(this.timeReminder ? this.timeReminder : $r('app.string.set_reminder'))
            .onClick(ev => {
              DatePickerDialog.show({
                start: new Date("2010-1-1"),
                end: new Date("2100-12-31"),
                selected: this.selectTime,
                onAccept: (value: DatePickerResult) => {
                  // 通过Date的setFullYear方法设置按下确定按钮时的日期，这样当弹窗再次弹出时显示选中的是上一次确定的日期
                  this.selectTime.setFullYear(value.year, value.month, value.day)
                  this.todoItem.date = this.selectTime.getTime()
                  this.timeReminder = value.year + "-" + (value.month + 1) + "-" +  value.day
                },
                onCancel: () => {
                  console.info("DatePickerDialog:onCancel()")
                },
              })
            })
            .fontSize(15)
            .textAlign(TextAlign.Start)
            .margin({ right: 5 })
          Image($r('app.media.ic_cancel'))
            .width(20)
            .height(20)
            .padding(2)
            .visibility(this.timeReminder ? Visibility.Visible : Visibility.Visible)
            .onClick(ev => {
              this.timeReminder = ""
              this.selectTime = new Date()

            })
        }
        .justifyContent(FlexAlign.Center)
        .margin({ right: 20 })
        .padding({ top: 5, right: 8, bottom: 5, left: 8 })
        .backgroundColor($r('app.color.bg_gray'))
        .borderRadius(3)

        Text($r('app.string.finish'))
          .fontSize(18)
          .fontColor(this.todoItem.title ? $r('app.color.orange') : $r('app.color.bg_gray'))
          .hitTestBehavior(this.todoItem.title ? HitTestMode.Default : HitTestMode.None)
          .onClick(ev => {
            if (this.todoItem.id) {
              this.updateTodo()
            }else{
              this.addTodo()
            }
          })
      }.width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }.width('100%')
    .padding(15)
    .margin({ bottom: 20 })
    // dialog默认的borderRadius为24vp，如果需要使用border属性，请和borderRadius属性一起使用。
  }

  addTodo() {
    if (!this.todoItem.content){
      this.todoItem.content = ""
    }

    postForm(`lg/todo/add/json`,
      `title=${encodeURIComponent(this.todoItem.title)}&content=${encodeURIComponent(this.todoItem.content)}&date=${dateFormat('YYYY-MM-DD',this.selectTime)}`
    ).then(data => {
      this.confirm()
      this.controller.close()
      this.writeAlert()
    }).catch(err=>{
      promptAction.showToast(err)
    })
  }

  updateTodo() {
    postForm(`lg/todo/update/${this.todoItem.id}/json`,
      `title=${encodeURIComponent(this.todoItem.title)}&content=${encodeURIComponent(this.todoItem.content)}&date=${dateFormat('YYYY-MM-DD',this.selectTime)}`)
      .then(data => {
        promptAction.showToast({ message: '更新成功' })
        this.confirm()
        this.controller.close()
        this.writeAlert()
      })
  }

  openCanAlert(){

  }

  writeAlert(){
    Reminder.reminder(this.selectTime)
  }
}