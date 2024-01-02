
import http from '@ohos.net.http';

export class HttpRequest {
  url: string

  method: string

  headers: object

  body: string | Object | ArrayBuffer;


  constructor(data: Partial<HttpRequest>) {
    Object.assign(this, data);
  }
}

export class HttpResponse {

  url: string

  result: string | Object | ArrayBuffer;

  resultType: http.HttpDataType;

  responseCode: number;

  header: Object;

  cookies: string;

  body: string | Object | ArrayBuffer;


  constructor(data: Partial<HttpResponse>) {
    Object.assign(this, data);
  }
}
