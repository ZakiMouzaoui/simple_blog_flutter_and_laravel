import 'package:get/get.dart';
import 'package:simple_blog_laravel/controllers/post_controller.dart';
import 'package:simple_blog_laravel/controllers/user_controller.dart';

class MyBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => UserController());
    Get.lazyPut(() => PostController());
  }
}