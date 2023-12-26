
import HttpBuilder from './HttpBuilder'
import Resource from '../entity/Resource'

let builder = new HttpBuilder({
  baseUrl : 'https://www.wanandroid.com/',
  connectTimeOut: 12000,
  readTimeout: 12000,
  header:{
    'Content-Type': 'application/json',
  }
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