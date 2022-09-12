import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_blog_laravel/constant.dart';
import 'package:simple_blog_laravel/controllers/user_controller.dart';
import 'package:simple_blog_laravel/services/user_service.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final userService = UserService();
  final userController = Get.find<UserController>();

  void _loadUserInfo() async{
    final token = await userService.getToken();

    if(token == ""){
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => const LoginScreen()
      ));
    }

    else{
      final apiResponse = await userController.getDetails();

      if(apiResponse.error == null){
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => HomeScreen()
        ));
      }
      else{
        if(apiResponse.error == unauthorized){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => const LoginScreen()
          ));
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(apiResponse.error!),
              )
          );
        }
      }
    }
  }

  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}
