import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:simple_blog_laravel/controllers/user_controller.dart';

class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget({Key? key, required this.onTap, required this.btnText}) : super(key: key);

  final Callback onTap;
  final String btnText;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 15,bottom: 15),
        decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(20)
        ),
        child: GetBuilder<UserController>(
          builder: (builder) => Center(
            child: controller.isLoading.value ? const CircularProgressIndicator(
              color: Colors.white,
            ):Text(
              btnText,
              style: const TextStyle(
                  color: Colors.black
              ),),
          ),
        )
      ),
    );
  }
}
