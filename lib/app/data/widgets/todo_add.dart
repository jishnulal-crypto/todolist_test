import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:todolist/app/data/database_sqflite.dart';
import 'package:todolist/app/data/notification_widgets.dart';
import 'package:todolist/app/data/utils.dart';
import 'package:todolist/app/models/todo.dart';
import 'package:todolist/app/modules/home/controllers/home_controller.dart';

class TodoController extends GetxController {
  late DbInitializer dbInitializer;
  @override
  void onInit() {
    dbInitializer = Get.find<DbInitializer>();
    super.onInit();
  }
}

class TodoAdd extends StatelessWidget {
  TodoAdd({super.key});

  TextEditingController label = TextEditingController();
  TextEditingController description = TextEditingController();
  final TodoController todoController = Get.put(TodoController());
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 500,
      child: AlertDialog(
        backgroundColor: Colors.blue[100],
        content: Container(
          width: 300,
          height: 300,
          child: Form(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("label"),
              SizedBox(
                height: 4,
              ),
              Container(
                child: TextFormField(
                  controller: label,
                  onChanged: (value) {},
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text("description"),
              TextFormField(
                controller: description,
                onChanged: (value) {
                  print(value);
                },
              )
            ],
          )),
        ),
        actions: [
          AddButton(add: () async {
            bool found = false;
            if (label.text.isEmpty && description.text.isEmpty) {
              showSnackbarTodonow(context, 'enter the text');
              return;
            }

            if (previousTodos!.length == 0 &&
                (label.text.isNotEmpty && description.text.isNotEmpty)) {
              var todo = Todo(
                  done: 1, name: label.text, description: description.text);
              todoController.dbInitializer.insertTodo(todo);
              homeController.fetchTodos();
              setPreviousTodo(todo);
            } else if (previousTodos!.length > 0 &&
                (label.text.isNotEmpty && description.text.isNotEmpty)) {
              previousTodos!.forEach((element) {
                if (label.text == element!.name ||
                    description.text == element!.description) {
                  found = true;
                  showSnackbarTodonow(context, 'todo exists already');
                }
              });

              if (found) {
                return;
              } else {
                var todo = Todo(
                    done: 1, name: label.text, description: description.text);
                todoController.dbInitializer.insertTodo(todo);
                homeController.fetchTodos();
                setPreviousTodo(todo);
                showSnackbarTodonow(context, 'todo added sucessfully');
              }
            }

            // var todo =
            //     Todo(done: 1, name: label.text, description: description.text);
            // todoController.dbInitializer.insertTodo(todo);
            // homeController.fetchTodos();
            // setPreviousTodo(todo);
          }),
          RemoveButton(remove: () {
            label.clear();
            description.clear();
          })
        ],
      ),
    );
  }

  void setPreviousTodo(Todo todo) {
    previousTodos!.add(todo);
  }
}

class AddButton extends StatelessWidget {
  AddButton({required this.add, super.key});

  VoidCallback add;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: add, child: Text("Add"));
  }
}

class RemoveButton extends StatelessWidget {
  RemoveButton({required this.remove, super.key});
  VoidCallback remove;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: remove, child: Text("clear"));
  }
}

void showSnackbarTodonow(BuildContext context, String label) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label)));
}
