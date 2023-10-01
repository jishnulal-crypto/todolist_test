import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:todolist/app/data/database_sqflite.dart';
import 'package:todolist/app/data/notification_widgets.dart';
import 'package:todolist/app/data/widgets/todo_add.dart';
import 'package:todolist/app/models/todo.dart';
import 'package:todolist/app/modules/home/controllers/home_controller.dart';

class UpdateTodoController extends GetxController {
  late DbInitializer dbInitializer;
  @override
  void onInit() {
    dbInitializer = Get.find<DbInitializer>();
    super.onInit();
  }
}

class TodoUpdate extends StatelessWidget {
  TodoUpdate({super.key, required this.updateKey});

  final String? updateKey;
  TextEditingController label = TextEditingController();
  TextEditingController description = TextEditingController();
  final UpdateTodoController todoController = Get.put(UpdateTodoController());
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
            } else {
              var todo = Todo(
                  done: 1, name: label.text, description: description.text);
              todoController.dbInitializer.updateTodo(todo, updateKey!);
              homeController.fetchTodos();
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
}

class UpdateButton extends StatelessWidget {
  UpdateButton({required this.add, super.key});

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
