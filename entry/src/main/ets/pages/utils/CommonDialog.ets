import promptAction from '@ohos.promptAction';

const dialog = {

  openDialog(title, message, buttons) {
    promptAction.showDialog({
      title: title,
      message: message,
      buttons: buttons,
    }).then(data => {
      console.info('showDialog success, click button: ' + data.index);
      buttons[data.index].onClick()

    })
  },

  openSingleDialog(title, message, positiveButtonConfig) {
    this.openDialog(title, message,
      [
        {
          text: positiveButtonConfig.text,
          color: positiveButtonConfig.color ? positiveButtonConfig.color: '#000000',
          onClick: positiveButtonConfig.onClick ? positiveButtonConfig.onClick : ()=>{}
        }
      ]);
  },

  openDoubleDialog(title: string, message: string, positiveButtonConfig: any, negativeButtonConfig: any) {
    this.openDialog(title, message,
      [
        {
          text: positiveButtonConfig.text,
          color: positiveButtonConfig.color ? positiveButtonConfig.color: '#000000',
          onClick: positiveButtonConfig.onClick ? positiveButtonConfig.onClick : ()=>{}
        },
        {
          text: negativeButtonConfig.text,
          color: negativeButtonConfig.color ? negativeButtonConfig.color: '#000000',
          onClick: negativeButtonConfig.onClick ? negativeButtonConfig.onClick : ()=>{}
        }
      ]);

  },
}

export default dialog