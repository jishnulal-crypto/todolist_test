import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:todolist/app/data/utils.dart';
import 'package:todolist/app/data/widgets/todo_add.dart';
import 'package:todolist/app/data/widgets/todo_update.dart';
import 'package:todolist/app/models/todo.dart';

import '../controllers/home_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final HomeController todoController = Get.put(HomeController());

  HomeScreen({Key? key}) : super(key: key);

  var _selectedIndex = 0.obs;
  var indexforup_del = 0.obs;
  Todo? currentTodo;
  void _onItemTapped(int index) {
    // Handle tab selection
    if (_selectedIndex.value != index) {
      _selectedIndex.value = index;
      // You may want to add logic for switching between list and grid views here.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: AppBar(
        title: Text('TodoList'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: ((context) {
              return TodoAdd();
            }),
          );
        },
      ),
      body: Obx(
        () => (_selectedIndex == 0)
            ? todoController.todos.length > 0
                ? ListView.builder(
                    itemCount: todoController.todos.length,
                    itemBuilder: (context, index) {
                      final todo = todoController.todos[index];
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          color: Colors.amber[300],
                          child: ListTile(
                            style: ListTileStyle.drawer,
                            title: Text(todo.name!),
                            subtitle: Text(todo.description!),
                            trailing: Text("task ${index + 1}"),
                            // Add other UI elements based on your Todo model.
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text("Todo Empty"),
                  )
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: todoController.todos.isEmpty
                        ? Center(
                            child: Text("Todo Empty"),
                          )
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            ),
                            itemCount: todoController.todos.length,
                            itemBuilder: (context, index) {
                              final todo = todoController.todos[index];

                              return GestureDetector(
                                  onTap: () {
                                    indexforup_del.value = index;
                                    currentTodo = Todo(
                                        done: 1,
                                        name: todo.name,
                                        description: todo.description);
                                    print('selected index');
                                    print(indexforup_del.value);
                                    print('index');
                                    print(index);

                                    // Handle grid item selection, you may want to add logic for updating the selected item.
                                  },
                                  child: Obx(
                                    () => Container(
                                      decoration: BoxDecoration(
                                          boxShadow: indexforup_del == index
                                              ? [
                                                  BoxShadow(
                                                    blurRadius: 10,
                                                    color: Colors.black45,
                                                  ),
                                                ]
                                              : []),
                                      child: Card(
                                        color: Colors.amber[300],
                                        child: ListTile(
                                          title: Text(todo!.name!),
                                          subtitle: Text(todo.description!),
                                          // Add other UI elements based on your Todo model.
                                        ),
                                      ),
                                    ),
                                  ));
                            },
                          ),
                  ),
                  Positioned(
                    top: 400,
                    child: SizedBox(
                      width: 400,
                      height: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(100, 50),
                              ),
                              onPressed: () {
                                if (todoController.todos.isEmpty) {
                                  showSnackbarTodonow(
                                      context, 'please Add a todo');
                                  return;
                                } else if (todoController.todos.isNotEmpty &&
                                    currentTodo == null) {
                                  showSnackbarTodonow(
                                      context, 'please Select a todo');
                                  return;
                                }
                                deleteItem();
                              },
                              child: Text('delete')),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(100, 50),
                                  backgroundColor: Colors.blue[200]),
                              onPressed: () {
                                if (todoController.todos.isEmpty) {
                                  showSnackbarTodonow(
                                      context, 'please Add a todo');
                                  return;
                                } else if (todoController.todos.isNotEmpty &&
                                    currentTodo == null) {
                                  showSnackbarTodonow(
                                      context, 'please Select a todo');
                                  return;
                                }
                                updateItem(context, currentTodo!.name!);
                              },
                              child: Text('update'))
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_on),
            label: 'manage',
          ),
        ],
        currentIndex: _selectedIndex.value,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  void deleteItem() {
    todoController.database.deleteTodo(currentTodo!.name!);
    if (previousTodos!.contains(currentTodo!.name)) {
      previousTodos!
          .removeWhere((element) => element.name == currentTodo!.name);
    }
    todoController.fetchTodos();
  }

  void updateItem(BuildContext context, String name) {
    showDialog(
        context: context,
        builder: (context) {
          return TodoUpdate(
            updateKey: name,
          );
        });
  }

  void showSnackbarTodonow(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label)));
  }
}
