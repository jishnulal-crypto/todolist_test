import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:todolist/app/data/database_sqflite.dart';

import '../../../models/todo.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  late DbInitializer database;
  RxList<Todo> todos = RxList<Todo>.empty();
  @override
  void onInit() {
    database = Get.find<DbInitializer>();
    if (todos.length <= 0) {
      fetchTodos();
    } else {
      ever(todos, (callback) => fetchTodos());
    }

    super.onInit();
  }

  fetchTodos() async {
    // await database.insertTodo(
    //     Todo(done: 1, name: 'firstTask', description: 'brush your teeth'));
    todos.value = await database.todos();
    todos.forEach((element) {
      element.name;
    });
  }
}
