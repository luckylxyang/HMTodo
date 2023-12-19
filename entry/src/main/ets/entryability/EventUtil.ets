import hiAppEvent from '@ohos.hiviewdfx.hiAppEvent';
import hilog from '@ohos.hilog';

export function  eventWatch(){
  hiAppEvent.addWatcher({
    // 开发者可以自定义观察者名称，系统会使用名称来标识不同的观察者
    name: "watcher1",
    // 开发者可以订阅感兴趣的应用事件，此处是订阅了按钮事件
    appEventFilters: [{ domain: "button" }],
    // 开发者可以设置订阅回调触发的条件，此处是设置为事件打点数量满足1个
    triggerCondition: { row: 1 },
    // 开发者可以自行实现订阅回调函数，以便对订阅获取到的事件打点数据进行自定义处理
    onTrigger: function (curRow, curSize, holder) {
      // 返回的holder对象为null，表示订阅过程发生异常，因此在记录错误日志后直接返回
      if (holder == null) {
        hilog.error(0x0000, 'testTag', "HiAppEvent holder is null")
        return
      }
      let eventPkg = null
      // 根据设置阈值大小（默认为512KB）去获取订阅事件包，直到将订阅数据全部取出
      // 返回的事件包对象为null，表示当前订阅数据已被全部取出，此次订阅回调触发结束
      while ((eventPkg = holder.takeNext()) != null) {
        // 开发者可以对事件包中的事件打点数据进行自定义处理，此处是将事件打点数据打印在日志中
        hilog.info(0x0000, 'testTag', `HiAppEvent eventPkg.packageId=%{public}d`, eventPkg.packageId)
        hilog.info(0x0000, 'testTag', `HiAppEvent eventPkg.row=%{public}d`, eventPkg.row)
        hilog.info(0x0000, 'testTag', `HiAppEvent eventPkg.size=%{public}d`, eventPkg.size)
        for (const eventInfo of eventPkg.data) {
          hilog.info(0x0000, 'testTag', `HiAppEvent eventPkg.info=%{public}s`, eventInfo)
        }
      }
    }
  })
}