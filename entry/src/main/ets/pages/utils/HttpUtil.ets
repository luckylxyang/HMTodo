// 引入包名
import http from '@ohos.net.http';
import { Api } from '../net/ApiConstants';
import Resource from '../entity/Resource'
import PreferencesUtil from './PreferencesUtil';


export function httpGetEntity<T>(url, success, error?) {
  url = getUrl(url)
  let httpRequest = http.createHttp();
  httpRequest.on('headersReceive', (header) => {
    console.info('header: ' + JSON.stringify(header));
  });
  let cookie = AppStorage.SetAndProp("cookie", "").get()
  httpRequest.request(
    url,
    {
      method: http.RequestMethod.GET, // 可选，默认为http.RequestMethod.GET
      header: {
        'Content-Type': 'application/json',
        'Cookie': cookie
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
      console.info('cookies:' + JSON.stringify(data.cookies));

      let result = <Resource<T>> data.result
      if (data.responseCode == 200 && result.errorCode === 0) {
        let res = result.data
        success(res)
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

export function httpGet(url, success, error?) {
  url = getUrl(url)
  let httpRequest = http.createHttp();
  httpRequest.on('headersReceive', (header) => {
    console.info('header: ' + JSON.stringify(header));
  });
  let cookie = ""
  PreferencesUtil.getInstance().get("cookie")
    .then(data => {
      cookie = <string> data
    })
  httpRequest.request(
    url,
    {
      method: http.RequestMethod.GET, // 可选，默认为http.RequestMethod.GET
      header: {
        'Content-Type': 'application/json',
        'Cookie': cookie
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
  // let cookie = ""
  // PreferencesUtil.getInstance().get("cookie")
  //   .then(data => {
  //     cookie = <string> data
  //   })
  url = getUrl(url)
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
        if (url.includes("login")) {
          saveCookie(data.cookies)
        }
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
  let cookie = AppStorage.SetAndProp("cookie", "").get()
  // PreferencesUtil.getInstance().get("cookie")
  //   .then(data => {
  //     cookie = <string> data
  //   })
  url = getUrl(url)
  let httpRequest = http.createHttp();

  return new Promise<any>((resolve, reject) => {
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
        console.info('code:' + JSON.stringify(data.responseCode));
        // data.header为HTTP响应头，可根据业务需要进行解析
        console.info('header:' + JSON.stringify(data.header));
        console.info('body:' + JSON.stringify(params));

        let result = JSON.parse(JSON.stringify(data.result))

        if (data.responseCode == 200 && result.errorCode === 0) {
          resolve(data.result)
          if (url.includes("login")) {
            saveCookie(data.cookies)
          }
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
          if (url.includes("login")) {
            saveCookie(data.cookies)
          }
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

function getUrl(url: string) {
  if (url.startsWith("http")) {
    return url;
  }
  return Api.baseURL + url
}

function saveCookie(cookies) {
  console.info('cookies:' + JSON.stringify(cookies))
  let cookie = parseCookieString(cookies);
  AppStorage.SetOrCreate("login", true)
  AppStorage.SetOrCreate("cookie", cookie)
  PreferencesUtil.getInstance().put("cookie", cookie)
    .then(() => {
      console.info("success")
    }).catch(err => {
    console.error(err)
  })
  PreferencesUtil.getInstance().flush()


  // console.log(JSON.stringify(cookie));
}

function parseCookieString(cookieString: string) {
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


