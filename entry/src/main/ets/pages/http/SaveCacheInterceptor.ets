import http from '@ohos.net.http';
import PreferencesUtil from '../utils/PreferencesUtil';
import { HttpResponse } from './Http';
import { ResponseInterceptor } from './Interceptor';

export class SaveCacheInterceptor implements ResponseInterceptor {

  onResponse(response: HttpResponse): HttpResponse | Promise<HttpResponse> {

    if (response.url.includes("login")) {
      this.saveCookie(response.cookies)
    }

    return response
  }

  saveCookie(cookies) {
    console.info('cookies:' + JSON.stringify(cookies))
    let cookie = this.parseCookieString(cookies);
    AppStorage.SetOrCreate("login", true)
    AppStorage.SetOrCreate("cookie", cookie)
    PreferencesUtil.getInstance().put("cookie", cookie)
      .then(() => {
        console.info("save cookie success")
      }).catch(err => {
      console.error(err)
    })
    PreferencesUtil.getInstance().flush()


    console.log(cookie);
  }

  parseCookieString(cookieString: string) {
    const cookies: Record<string, string> = {};

    // 使用正则表达式匹配每一组键值对
    const cookiePairs = cookieString.split(/\r\n/);

    let cookie = ""
    cookiePairs.forEach(pair => {
      const parts = pair.split(/\t/);
      const name = parts[5];
      const value = parts[6];
      if (name && value) {
        cookies[name] = decodeURIComponent(value);
        cookie += `${name}=${value};`
      }
    });
    return cookie;
  }
}