import hilog from '@ohos.hilog';
import PreferencesUtil from '../utils/PreferencesUtil';
import { HttpRequest, HttpResponse } from './Http';
import { RequestInterceptor, ResponseInterceptor } from './Interceptor';

export default class HeaderInterceptor implements RequestInterceptor {

  async onRequest(options: HttpRequest): Promise<HttpRequest> {
    let data = await PreferencesUtil.get("cookie", "")
    hilog.info(0x2233, "http_inter", <string>data)
    options.headers = {
      'Cookies': <string>data
    }
    return options
  }
}