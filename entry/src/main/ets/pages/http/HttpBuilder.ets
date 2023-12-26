import http from '@ohos.net.http'
import HttpClient from './HttpClient'
import Interceptor from './Interceptor'

export default class HttpBuilder {
  baseUrl: string
  connectTimeOut: number = 60000
  writeTimeOut: number = 120000
  readTimeout: number = 60000
  usingProtocol: http.HttpProtocol = http.HttpProtocol.HTTP1_1
  header: object

  private requestInterceptor: Interceptor[]
  private responseInterceptor: Interceptor[]

  private interceptors : Interceptor[]

  constructor(data: Partial<HttpBuilder>) {
    Object.assign(this, data);
  }

  addInterceptor(interceptor : Interceptor){
    this.interceptors.push(interceptor)
  }

  build() : HttpClient{
    return new HttpClient(this)
  }





}