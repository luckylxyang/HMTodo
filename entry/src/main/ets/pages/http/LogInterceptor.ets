import { HttpResponse } from './Http';
import { ResponseInterceptor } from './Interceptor';

export class LogInterceptor implements ResponseInterceptor {

  onResponse(response: HttpResponse): HttpResponse | Promise<HttpResponse> {
    throw new Error('Method not implemented.');
  }

}