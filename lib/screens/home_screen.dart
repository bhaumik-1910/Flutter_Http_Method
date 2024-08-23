import 'package:flutter/material.dart';
import 'package:http_method/controller/todo_controller.dart';
import 'package:http_method/models/todo.dart';
import 'package:http_method/repository/todo_repository.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //dependency injection
    var todoController = TodoController(TodoRepository());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('REST API'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Todo>>(
        future: todoController.fetchTodoList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('error'));
          }
          return buildBodyContent(snapshot, todoController);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Todo todo = Todo(userId: 3,title: 'sample post',completed: false);
          todoController.postTodo(todo);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  SafeArea buildBodyContent(AsyncSnapshot<List<Todo>> snapshot,
      TodoController todoController) {
    return SafeArea(
      child: ListView.separated(
          itemBuilder: (context, index) {
            var todo = snapshot.data?[index];
            return Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(flex: 1, child: Text('${todo?.id}')),
                  Expanded(flex: 3, child: Text('${todo?.title}')),
                  Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                              onTap: () {
                                todoController.updatePatchCompleted(todo!)
                                    .then(
                                      (value) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        duration: Duration(microseconds: 500),
                                        content: Text('$value'),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: buildCallContainer(
                                  'Patch', Color(0xFFFFE0B2))),
                          InkWell(
                              onTap: () {
                                todoController.updatePutCompleted(todo!);
                              },
                              child: buildCallContainer(
                                  'Put', Color(0xFFE1BEE7))),
                          InkWell(
                              onTap: () {
                                todoController.deleteTodo(todo!).then((value) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      duration: Duration(microseconds: 500),
                                      content: Text('$value'),
                                    ),
                                  );
                                });
                              },
                              child: buildCallContainer(
                                  'Del', Color(0xFFFFA8B96))),
                        ],
                      )),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              thickness: 0.5,
              height: 0.5,
            );
          },
          itemCount: snapshot.data?.length ?? 0),
    );
  }
}


//Create method call 40 line
Container buildCallContainer(String title, Color color) {
  return Container(
    width: 40,
    height: 40,
    decoration:
    BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
    child: Center(child: Text('${title}')),
  );
}
