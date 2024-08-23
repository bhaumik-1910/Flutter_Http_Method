import 'package:http_method/models/todo.dart';

abstract class Repository {
  //get
  Future<List<Todo>>getTodoList();
  //patch
  Future<String>patchCompleted(Todo todo);
  //put
  Future<String>putCompleted(Todo todo);
  //post
  Future<String>postTodo(Todo todo);
  //delete
  Future<String>deleteTodo(Todo todo);
}

