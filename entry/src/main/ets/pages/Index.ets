import deviceInfo from '@ohos.deviceInfo'
import device from '@system.device';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'

  aboutToAppear(){
    console.log(deviceInfo.deviceType)
    console.log(deviceInfo.manufacture)
    if (canIUse("SystemCapability.Startup.SystemInfo")) {
      console.log("该设备支持SystemCapability.ArkUI.ArkUI.Full");
    } else {
      console.log("该设备不支持SystemCapability.ArkUI.ArkUI.Full");
    }
  }

  getInfo() {
    device.getInfo({
      success: function(data) {
        console.log('Device information obtained successfully. Device brand:' + JSON.stringify(data));
      },
      fail: function(data, code) {
        console.log('Failed to obtain device information. Error code:'+ code + '; Error information: ' + data);
      },
    });
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(ev=>{
            this.getInfo()
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}