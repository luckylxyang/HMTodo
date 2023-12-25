
import reminderAgentManager from '@ohos.reminderAgentManager';
import notificationManager from '@ohos.notificationManager';
enum REMINDER_TYPE{
  ALARM = 1,
  CALENDAR,
  TIMER
}

const Reminder = {

  getAlertReminderAgent(){
    let targetReminderAgent: reminderAgentManager.ReminderRequestAlarm = {
      reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_ALARM, // 提醒类型为闹钟类型
      hour: 23, // 指明提醒的目标时刻
      minute: 9, // 指明提醒的目标分钟
      daysOfWeek: [2], // 指明每周哪几天需要重复提醒
      actionButton: [ // 设置弹出的提醒通知信息上显示的按钮类型和标题
        {
          title: 'close',
          type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
        },
        {
          title: 'snooze',
          type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_SNOOZE
        },
      ],
      wantAgent: { // 点击提醒通知后跳转的目标UIAbility信息
        pkgName: 'com.example.myapplication',
        abilityName: 'EntryAbility'
      },
      maxScreenWantAgent: { // 全屏显示提醒到达时自动拉起的目标UIAbility信息
        pkgName: 'com.example.myapplication',
        abilityName: 'EntryAbility'
      },
      ringDuration: 5, // 指明响铃时长（单位：秒）
      snoozeTimes: 2, // 指明延迟提醒次数
      timeInterval: 5, // 执行延迟提醒间隔（单位：秒）
      title: 'this is title', // 指明提醒标题
      content: 'this is content', // 指明提醒内容
      expiredContent: 'this reminder has expired', // 指明提醒过期后需要显示的内容
      snoozeContent: 'remind later', // 指明延迟提醒时需要显示的内容
      notificationId: 99, // 指明提醒使用的通知的ID号，相同ID号的提醒会覆盖
      slotType: notificationManager.SlotType.SOCIAL_COMMUNICATION // 指明提醒的Slot类型
    }

    return targetReminderAgent
  },

  getCalendarReminder(reminderDate : Date){
    let targetReminderAgent: reminderAgentManager.ReminderRequestCalendar = {
      reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_CALENDAR, // 提醒类型为日历类型
      dateTime: { // 指明提醒的目标时间
        year: 2023,
        month: 12,
        day: 25,
        hour: 16,
        minute: 11,
        second: 0
      },
      repeatMonths: [1], // 指明重复提醒的月份
      repeatDays: [1], // 指明重复提醒的日期
      actionButton: [// 设置弹出的提醒通知信息上显示的按钮类型和标题
        {
          title: 'close',
          type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
        },
        {
          title: 'snooze',
          type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_SNOOZE
        },
      ],
      wantAgent: { // 点击提醒通知后跳转的目标UIAbility信息
        pkgName: 'com.lxy.todo',
        abilityName: 'EntryAbility'
      },
      maxScreenWantAgent: { // 全屏显示提醒到达时自动拉起的目标UIAbility信息
        pkgName: 'com.lxy.todo',
        abilityName: 'EntryAbility'
      },
      ringDuration: 5, // 指明响铃时长（单位：秒）
      snoozeTimes: 2, // 指明延迟提醒次数
      timeInterval: 5, // 执行延迟提醒间隔（单位：秒）
      title: 'this is title', // 指明提醒标题
      content: 'this is content', // 指明提醒内容
      expiredContent: 'this reminder has expired', // 指明提醒过期后需要显示的内容
      snoozeContent: 'remind later', // 指明延迟提醒时需要显示的内容
      notificationId: 100, // 指明提醒使用的通知的ID号，相同ID号的提醒会覆盖
      slotType: notificationManager.SlotType.SOCIAL_COMMUNICATION // 指明提醒的Slot类型
    }
    return targetReminderAgent
  },



  reminder(date : Date){
    let targetReminderAgent = this.getCalendarReminder(date)
    reminderAgentManager.publishReminder(targetReminderAgent).then(res => {
      console.info('Succeeded in publishing reminder. ' + res);
      let reminderId: number = res; // 发布的提醒ID
    }).catch(err => {
      console.error(`Failed to publish reminder. Code: ${err.code}, message: ${err.message}`);
    })
  }
}

export default Reminder;