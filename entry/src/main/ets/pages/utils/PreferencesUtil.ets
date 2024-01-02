import data_preferences from '@ohos.data.preferences';

const PREFERENCES_NAME = 'wan_android'; // 首选项名字

let preference = null
let context = getContext(this)
class PreferencesUtil {

  async getPreferencesFromStorage(){
    try {
      preference = await data_preferences.getPreferences(context, PREFERENCES_NAME);
    } catch (err) {
      console.error(`Failed to get preferences. Code:${err.code},message:${err.message}`);
    }
  }

  async get(key, defaultValue?) {
    if (!preference) {
      await this.getPreferencesFromStorage();
    }
    return preference.get(key, defaultValue ? defaultValue : "")
  }

  async put(key, value) {
    if (!preference) {
      await this.getPreferencesFromStorage();
    }
    await preference.put(key, value)
    return this.flush()
  }

  async has( key) {
    if (!preference) {
      await this.getPreferencesFromStorage();
    }
    return preference.has(key)

  }

  async deleteKey(key) {
    return new Promise<void>((resolve, reject) => {
      preference.delete(key).then(() => {
        resolve()
      }).catch(err => {
        reject(err)
      })
    })
  }

  async flush() {
    if (!preference) {
      await this.getPreferencesFromStorage();
    }
    return preference.flush()
  }
}

export default new PreferencesUtil()

