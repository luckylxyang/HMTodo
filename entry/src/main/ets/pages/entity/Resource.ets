
export default class Resource<T> {
  data: T;
  errorCode: number;
  errorMsg: string;

  // constructor(data: T, errorCode: number, errorMsg: string) {
  //   this.data = data;
  //   this.errorCode = errorCode;
  //   this.errorMsg = errorMsg;
  // }

  constructor(data: Partial<Resource<T>>) {
    Object.assign(this, data);
  }
}