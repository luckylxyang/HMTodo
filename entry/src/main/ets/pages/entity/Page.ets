
export default class Page<T> {
  curPage: number;
  datas: T[];
  offset: number;
  over: boolean;
  pageCount: number;
  size: number;
  total: number;

  constructor(data: Partial<Page<T>>) {
    Object.assign(this, data);
  }
}