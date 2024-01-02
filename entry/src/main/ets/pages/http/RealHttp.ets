// 引入包名
import http from '@ohos.net.http';
import { HttpRequest, HttpResponse } from './Http';
import HttpBuilder from './HttpBuilder';


export function get<T>(url, build?: HttpBuilder): Promise<T> {
  return request<T>(url, http.RequestMethod.GET, build)
}

export function post<T>(url, params, build?: HttpBuilder): Promise<T> {
  return request<T>(url, http.RequestMethod.POST, params, build)
}

async function request<T>(url, method: http.RequestMethod, params?, build?: HttpBuilder): Promise<T> {

  let httpClient = http.createHttp();
  httpClient.on('headersReceive', (header) => {
    console.info('header: ' + JSON.stringify(header));
  });

  let request = new HttpRequest({
    url: url,
    method: method,
    headers: build?.headers,
    body: params
  })

  for (let item of build.requestInterceptor) {
    request = await item.onRequest(request)
  }

  let data = await httpClient.request(url, {
    method: method,
    header: request.headers,
    extraData: request.body,
    expectDataType: http.HttpDataType.OBJECT,
    usingCache: true,
    connectTimeout: build?.connectTimeOut,
    readTimeout: build?.readTimeout,
    usingProtocol: build?.usingProtocol,
  })
  let httpResponse = new HttpResponse({
    url: url,
    cookies: data.cookies,
    resultType: data.resultType,
    responseCode: data.responseCode,
    header: data.header,
    result: data.result
  })

  for (let item of build.responseInterceptor) {
    httpResponse = await item.onResponse(httpResponse)
  }

  let result = httpResponse.result as T;

  return result

}


export function httpPostFormPromise(url: string, params?) {
  let cookie = AppStorage.SetAndProp("cookie", "").get()
  let httpRequest = http.createHttp();
  return new Promise<any>((resolve, reject) => {
    httpRequest.request(
      url,
      {
        method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
        header: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Cookie': cookie
        },
        extraData: params,
        expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
        usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
      }, (err, data) => {
      if (!err) {
        // data.result为HTTP响应内容，可根据业务需要进行解析
        console.info('Url:' + url);
        console.info('Result:' + JSON.stringify(data.result));
        console.info('code:' + JSON.stringify(data.responseCode));
        // data.header为HTTP响应头，可根据业务需要进行解析
        console.info('header:' + JSON.stringify(data.header));
        console.info('body:' + JSON.stringify(params));

        let result = JSON.parse(JSON.stringify(data.result))

        if (data.responseCode == 200 && result.errorCode === 0) {
          resolve(data.result)
        } else {
          reject(result.errorMsg)
        }
        httpRequest.destroy();
      } else {
        console.info('error:' + JSON.stringify(err));
        reject(err)
        httpRequest.destroy();
      }
    });
  })

}


