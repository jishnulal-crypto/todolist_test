import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

void ShowTodoSnackBar({String? sucessMessage, String? failureMessage}) {
  if (sucessMessage != null) {
    Get.showSnackbar(GetSnackBar(
      snackPosition: SnackPosition.BOTTOM,
      title: 'hi',
      titleText: Text("hi guy"),
      message: sucessMessage,
      messageText: Text('$sucessMessage'),
      backgroundColor: Colors.blue,
      animationDuration: Duration(seconds: 2),
    ));
  } else {
    Get.showSnackbar(GetSnackBar(
      snackPosition: SnackPosition.BOTTOM,
      title: 'hi',
      titleText: Text("hi guy"),
      message: sucessMessage,
      messageText: Text('$failureMessage'),
      backgroundColor: Colors.blue,
    ));
  }
}

void showSnackbarTodonow(BuildContext context, String label) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label)));
}
