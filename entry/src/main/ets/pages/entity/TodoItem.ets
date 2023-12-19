
export default class TodoItem {
  completeDate: Date | null;
  completeDateStr: string;
  content: string;
  date: number;
  dateStr: string;
  id: number;
  priority: number;
  status: number;
  title: string;
  type: number;
  userId: number;

  constructor(data: Partial<TodoItem>) {
    Object.assign(this, data);
    // 将日期的时间戳转换为 Date 对象
    // if (data.date) {
    //   this.date = new Date(data.date);
    // }
  }
}