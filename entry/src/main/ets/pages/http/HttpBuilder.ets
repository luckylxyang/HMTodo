import Interceptor from './Interceptor'
import {httpGet, httpPost} from './RealHttp'

export default class Builder {
  baseUrl: string
  connectTimeOut: number
  writeTimeOut: number
  readTimeout: number

  requestInterceptor: Interceptor[]
  responseInterceptor: Interceptor[]

  interceptors : Interceptor[]

  addInterceptor(interceptor : Interceptor){
    this.interceptors.push(interceptor)
  }

  build() : Builder{
    return new Builder()
  }

  get(url :string){
    return httpGet(this.get(url))
  }

  getUrl(url : string){
    if (url.startsWith("http")) {
      return url
    }
    return this.baseUrl + url
  }

}