
import promptAction from '@ohos.promptAction';
const dialog = {

  openDialog(title, message, buttons){
    return promptAction.showDialog({
      title: title,
      message: message,
      buttons: buttons,
    }).then(data=>{
      console.info('showDialog success, click button: ' + data.index);
    })
  },

  openSingleDialog(title, message, posButtonName){
    return this.openDialog(title, message,
       [
        {
          text: posButtonName,
          color: '#000000',
        }
      ]);
  },

  openDoubleDialog(title, message, posButtonName, natButtonName){
    return this.openDialog(title, message,
      [
        {
          text: natButtonName,
          color: '#000000',
        },
        {
          text: posButtonName,
          color: '#000000',
        }
      ]);

  },
}

export default dialog