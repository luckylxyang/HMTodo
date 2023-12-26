
import Builder from './HttpBuilder'
import {get, post} from './RealHttp'

export default class HttpClient{
  private build : Builder

  constructor(build: Builder) {
    this.build = build
  }

  get<T>(url: ResourceStr) : Promise<T>{
    return get<T>(this.getUrl(url.toString()), this.build)
  }

  post<T>(url: ResourceStr, params?) : Promise<T>{
    return post<T>(this.getUrl(url.toString()), params ? params : {}, this.build)
  }

  private getUrl(url : string){
    return url.startsWith("http") ? url : this.build.baseUrl + url
  }
}