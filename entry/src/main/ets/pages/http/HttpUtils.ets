
import HttpBuilder from './HttpBuilder'
import Resource from '../entity/Resource'
import { SaveCacheInterceptor } from './SaveCacheInterceptor';
import HeaderInterceptor from './HeaderInterceptor';
import { LogInterceptor } from './LogInterceptor';

let builder = new HttpBuilder({
  baseUrl : 'https://www.wanandroid.com/',
  connectTimeOut: 12000,
  readTimeout: 12000,
  headers:{
    'Content-Type': 'application/json',
  },
  responseInterceptor: [new SaveCacheInterceptor(), new LogInterceptor()],
  requestInterceptor: [new HeaderInterceptor()]

})


export async function get<T>(url: string): Promise<T> {
  try {
    const result = await builder.build().get<Resource<T>>(url);

    if (result.errorCode === 0) {
      return result.data as T;
    } else {
      throw result.errorMsg;
    }
  } catch (err) {
    throw err;
  }
}

export async function post<T>(url: string, params?): Promise<T> {
  try {
    const result = await builder.build().post<Resource<T>>(url, params);

    if (result.errorCode === 0) {
      return result.data as T;
    } else {
      throw result.errorMsg;
    }
  } catch (err) {
    throw err;
  }
}

export async function postForm<T>(url: string, params?): Promise<T> {
  try {
    builder.headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    }
    const result = await builder.build().post<Resource<T>>(url, params);

    if (result.errorCode === 0) {
      return result.data as T;
    } else {
      throw result.errorMsg;
    }
  } catch (err) {
    throw err;
  }
}