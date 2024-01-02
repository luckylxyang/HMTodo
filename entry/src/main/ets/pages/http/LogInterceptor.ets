import { HttpResponse } from './Http';
import { ResponseInterceptor } from './Interceptor';

export class LogInterceptor implements ResponseInterceptor {

  onResponse(response: HttpResponse): HttpResponse | Promise<HttpResponse> {
    console.info('url:' + response.url + "\n" + JSON.stringify(response.header));
    console.info('Result:' + JSON.stringify(response.result));
    console.info('code:' + JSON.stringify(response.responseCode));
    // data.header为HTTP响应头，可根据业务需要进行解析
    console.info('header:' + JSON.stringify(response.header));
    console.info('body:' + JSON.stringify(response.body));

    return response
  }

}