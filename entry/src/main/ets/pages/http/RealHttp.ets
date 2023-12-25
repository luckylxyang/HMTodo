// 引入包名
import http from '@ohos.net.http';

export function httpGet(url, success, error?) {
  let httpRequest = http.createHttp();
  httpRequest.on('headersReceive', (header) => {
    console.info('header: ' + JSON.stringify(header));
  });
  httpRequest.request(
    url,
    {
      method: http.RequestMethod.GET, // 可选，默认为http.RequestMethod.GET
      header: {
        'Content-Type': 'application/json'
      },
      expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
      usingCache: true, // 可选，默认为true
      priority: 1, // 可选，默认为1
      connectTimeout: 60000, // 可选，默认为60000ms
      readTimeout: 60000, // 可选，默认为60000ms
      usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
    }, (err, data) => {
    if (!err) {
      // data.result为HTTP响应内容，可根据业务需要进行解析
      console.info('Url:' + url);
      console.info('Result:' + JSON.stringify(data.result));
      console.info('code:' + JSON.stringify(data.responseCode));
      // data.header为HTTP响应头，可根据业务需要进行解析
      console.info('header:' + JSON.stringify(data.header));
      console.info('cookies:' + JSON.stringify(data.cookies)); // 8+

      let result = JSON.parse(JSON.stringify(data.result))
      if (data.responseCode == 200 && result.errorCode === 0) {
        success(result.data)
      } else {
        error(result.errorMsg)
      }
      httpRequest.off('headersReceive');
      // 当该请求使用完毕时，调用destroy方法主动销毁
      httpRequest.destroy();
    } else {
      console.info('error:' + JSON.stringify(err));
      error(err)
      // 取消订阅HTTP响应头事件
      httpRequest.off('headersReceive');
      // 当该请求使用完毕时，调用destroy方法主动销毁
      httpRequest.destroy();
    }
  }
  );
}

export function httpPost(url: string, params, success, error?) {

  let httpRequest = http.createHttp();

  let cookie = AppStorage.SetAndProp("cookie", "").get()
  httpRequest.request(
    url,
    {
      method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
      header: {
        'Content-Type': 'application/json',
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
      // data.header为HTTP响应头，可根据业务需要进行解析
      console.info('header:' + JSON.stringify(data.header));

      let result = JSON.parse(JSON.stringify(data.result))

      if (data.responseCode == 200 && result.errorCode === 0) {
        success(data.result)

      } else {
        error(result.errorMsg)
      }
      httpRequest.off('headersReceive');
      // 当该请求使用完毕时，调用destroy方法主动销毁
      httpRequest.destroy();
    } else {
      console.info('error:' + JSON.stringify(err));
      error(err)
      // 取消订阅HTTP响应头事件
      httpRequest.off('headersReceive');
      // 当该请求使用完毕时，调用destroy方法主动销毁
      httpRequest.destroy();
    }
  }
  );
}

export function httpPostPromise(url: string, params?) {
  let httpRequest = http.createHttp();

  return new Promise<any>((resolve, reject) => {
    httpRequest.request(
      url,
      {
        method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
        header: {
          'Content-Type': 'application/json',
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
        httpRequest.off('headersReceive');
        // 当该请求使用完毕时，调用destroy方法主动销毁
        httpRequest.destroy();
      } else {
        console.info('error:' + JSON.stringify(err));
        reject(err)
        // 取消订阅HTTP响应头事件
        httpRequest.off('headersReceive');
        // 当该请求使用完毕时，调用destroy方法主动销毁
        httpRequest.destroy();
      }
    });
  })

}

export function httpPostFormPromise(url: string, params?) {
  let cookie = AppStorage.SetAndProp("cookie", "").get()
  url = getUrl(url)
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


