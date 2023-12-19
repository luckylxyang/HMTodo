
import Page from '../entity/Page'
import Resource from '../entity/Resource'
import TodoItem from '../entity/TodoItem'
import { httpGet, httpGetEntity } from '../utils/HttpUtil'
@Component
export default struct ListPage{

  @State todoList : Array<TodoItem> = []
  private pageIndex = 1

  aboutToAppear(){
    this.getData()
  }

  getData(){
    let url = `lg/todo/v2/list/${this.pageIndex}/json`
    httpGetEntity<Page<TodoItem>>(url, (data : Page<TodoItem>)=>{
      // let od: TodoItem[] = data.datas.map((it: any) => new TodoItem(it))
      this.todoList.push(...data.datas)
    }, error=>{

    })
  }

  build(){
    Column(){
      List(){
        ForEach(this.todoList, (item : TodoItem)=>{
          ListItem(){
            Row(){
              Checkbox()
                .select(item.status == 1)

              Text(item.title)
            }
          }
        })
      }.width('100%')
      .height('100%')
    }
  }
}