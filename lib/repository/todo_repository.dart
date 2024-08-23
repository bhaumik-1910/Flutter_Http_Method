import 'package:http_method/models/todo.dart';
import 'package:http_method/repository/repository.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TodoRepository implements Repository {
  //use http
  String dataURL = 'https://jsonplaceholder.typicode.com';

  //delete
  @override
  Future<String> deleteTodo(Todo todo) async{
    var url = Uri.parse('$dataURL/todos/${todo.id}');
    var result = "false";
    await http.delete(url).then((value){
      print(value.body);
      return result =  'true';
    });
    return result;
  }

  //get example
  @override
  Future<List<Todo>> getTodoList() async {
    List<Todo> todoList = [];
    // https://jsonplaceholder.typicode.com/todos
    var url = Uri.parse('$dataURL/todos');
    var response = await http.get(url);
    print("Status code : ${response.statusCode}");
    var body = jsonDecode(response.body); //convert
    //parse
    for (var i = 0; i < body.length; i++) {
      todoList.add(Todo.fromJson(body[i]));
    }
    return todoList;
  }

  //patch example
  @override
  Future<String> patchCompleted(Todo todo) async {
    var url = Uri.parse('$dataURL/todos/${todo.id}');
    //call back data
    String resData = '';
    await http.patch(
      url,
      body: {
        'completed': (!todo.completed!).toString(),
      },
      headers: {'Authorization': 'your_token'},
    ).then((response) {
     //HomeScreen -> data
      Map<String,dynamic>result = json.decode(response.body);
      return resData = result['completed'];
    });
    return resData;
  }

  @override
  Future<String> putCompleted(Todo todo) async{
    var url = Uri.parse('$dataURL/todos/${todo.id}');
    //call back data
    String resData = '';
    await http.put(
      url,
      body: {
        'completed': (!todo.completed!).toString(),
      },
      headers: {'Authorization': 'your_token'},
    ).then((response) {
      //HomeScreen -> data
      Map<String,dynamic>result = json.decode(response.body);
      print(result);
      return resData = result['completed'];
    });
    return resData;
  }

  @override
  Future<String> postTodo(Todo todo) async{
   print('${todo.toJson()}');
   var url = Uri.parse('$dataURL/todos/');
   var response =  await http.put(url,body:todo.toJson());
   print(response.statusCode);
   print(response.body);
   return 'true';
  }
}
