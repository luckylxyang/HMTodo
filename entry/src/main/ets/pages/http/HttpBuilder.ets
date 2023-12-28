import http from '@ohos.net.http'
import HttpClient from './HttpClient'
import { RequestInterceptor,ResponseInterceptor } from './Interceptor'

export default class HttpBuilder {
  baseUrl: string
  connectTimeOut: number = 60000
  writeTimeOut: number = 120000
  readTimeout: number = 60000
  usingProtocol: http.HttpProtocol = http.HttpProtocol.HTTP1_1
  headers: object
  tempUrl: string
  requestInterceptor: RequestInterceptor[]
  responseInterceptor: ResponseInterceptor[]

  constructor(data: Partial<HttpBuilder>) {
    Object.assign(this, data);
  }


  setRequestInterceptor(interceptor : RequestInterceptor){
    this.requestInterceptor.push(interceptor)
    return this
  }

  setResponseInterceptor(interceptor : ResponseInterceptor){
    this.responseInterceptor.push(interceptor)
    return this
  }

  build(): HttpClient {
    return new HttpClient(this)
  }
}