import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBar(title, message){
  Get.snackbar(
      "",
      message,
      snackPosition: SnackPosition.BOTTOM,
      titleText: Text(
        "$title",
        style: const TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold
        ),
      ),
      snackStyle: SnackStyle.FLOATING,
      forwardAnimationCurve: Curves.bounceOut
  );
}