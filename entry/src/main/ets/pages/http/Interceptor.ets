import http from '@ohos.net.http';

export interface Chain{
  request(): http.HttpRequest

  proceed(request: http.HttpRequest): http.HttpResponse;
}

export default interface Interceptor {

  intercept(chain: Chain) : http.HttpResponse;


}