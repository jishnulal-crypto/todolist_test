import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/data/database_sqflite.dart';
import 'package:todolist/app/models/todo.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register DbInitializer with GetX
  await Get.putAsync(() => DbInitializer().initDB());

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
