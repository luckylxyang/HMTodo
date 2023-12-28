import http from '@ohos.net.http';
import HttpBuilder from './HttpBuilder';
import { HttpRequest, HttpResponse } from './Http';

export interface Chain{
  request(): HttpRequest

  proceed(request: HttpRequest): http.HttpResponse;
}

export interface RequestInterceptor {
  onRequest(options: HttpRequest): HttpRequest | Promise<HttpRequest>;
}

export interface ResponseInterceptor {
  onResponse(response: HttpResponse): HttpResponse | Promise<HttpResponse>;
}