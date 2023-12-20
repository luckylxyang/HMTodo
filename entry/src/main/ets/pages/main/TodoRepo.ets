
import TodoItem from '../entity/TodoItem'
import { httpPost, httpPostPromise } from '../utils/HttpUtil'
const Repo = {

  getTodoList(){

  },

  addTodo(todo : TodoItem){

  },

  updateTodo(todo : TodoItem){

  },

  deleteTodo(todoId: number){
    return httpPostPromise(`lg/todo/done/${todoId}/json`)
  }
}