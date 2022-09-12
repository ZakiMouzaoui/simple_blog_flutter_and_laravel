import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_blog_laravel/screens/add_post_screen.dart';
import 'package:simple_blog_laravel/screens/posts_screen.dart';
import 'package:simple_blog_laravel/screens/profile_screen.dart';

import '../controllers/post_controller.dart';
import '../controllers/user_controller.dart';
import 'login_screen.dart';

class HomeScreen extends GetView<UserController> {
  HomeScreen({Key? key}) : super(key: key);
  final userController = Get.find<UserController>();
  final postController = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    final screens = [PostsScreen(), ProfileScreen()];

    return GetBuilder<PostController>(
      builder: (_) => Scaffold(
        floatingActionButton: postController.currentPageIndex.value == 0
            ? FloatingActionButton(
            backgroundColor: Theme.of(context).backgroundColor,
            child: const Icon(
              Icons.add,
              color: Colors.amber,
            ),
            onPressed: (){
              Get.to(()=>AddPostScreen());
            }
        ) : null,
        appBar: AppBar(
          title: const Text("Blog App"),
          actions: [
            GestureDetector(
              onTap: () {
                userController.logout();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (builder) => const LoginScreen()));
              },
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                child: const Icon(Icons.logout),
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: true,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
            ],
            backgroundColor: Colors.black12,
            showUnselectedLabels: false,
            selectedItemColor: Colors.amber,
            currentIndex: postController.currentPageIndex.value,
            onTap: (newIndex) {
              postController.changePageIndex(newIndex);
            },
          ),
        body: IndexedStack(
          children: screens,
          index: postController.currentPageIndex.value,
        ),
    ))
    ;
  }
}
