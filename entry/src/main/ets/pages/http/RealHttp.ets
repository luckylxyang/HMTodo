// 引入包名
import http from '@ohos.net.http';
import HttpBuilder from './HttpBuilder';


export function get<T>(url, build? : HttpBuilder): Promise<T> {
  return request<T>(url, http.RequestMethod.GET, build)
}

export function post<T>(url, params, build? : HttpBuilder): Promise<T> {
  return request<T>(url, http.RequestMethod.POST, params, build)
}

export function request<T>(url, method : http.RequestMethod, params?, build? : HttpBuilder): Promise<T> {
  let httpRequest = http.createHttp();
  httpRequest.on('headersReceive', (header) => {
    console.info('header: ' + JSON.stringify(header));
  });
  return new Promise<T>((resolve, reject) => {
    httpRequest.request(
      url,
      {
        method: method,
        header: {
          'Content-Type': 'application/json',
        },
        extraData: params,
        expectDataType: http.HttpDataType.OBJECT,
        usingCache: true,
        connectTimeout: build?.connectTimeOut,
        readTimeout: build?.readTimeout,
        usingProtocol: build?.usingProtocol,
      }, (err, data) => {
      try {
        console.info('Url:' + url);
        if (!err) {
          console.info('Result:' + JSON.stringify(data.result));
          console.info('code:' + JSON.stringify(data.responseCode));
          console.info('header:' + JSON.stringify(data.header));
          console.info('cookies:' + JSON.stringify(data.cookies)); // 8+

          let result = data.result as T;
          resolve(result);
        } else {
          console.info('error:' + JSON.stringify(err));
          reject(err);
        }
      } finally {
        httpRequest.off('headersReceive');
        httpRequest.destroy();
      }
    });
  })

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


