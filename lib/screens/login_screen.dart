import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_blog_laravel/controllers/post_controller.dart';
import 'package:simple_blog_laravel/controllers/user_controller.dart';
import 'package:simple_blog_laravel/screens/register_screen.dart';
import 'package:simple_blog_laravel/widgets/login_or_register_widget.dart';
import 'package:simple_blog_laravel/widgets/text_button_widget.dart';
import 'package:simple_blog_laravel/widgets/text_field_widget.dart';

import '../utils.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    final controller = Get.find<UserController>();

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFieldWidget(
                      labelText: "Email",
                    controller: _emailController,
                    validation: (_value) => _value!.isEmpty
                        ? "The email field is required"
                        : !isValidEmail(_value) ? "Please enter a valid email"
                        : null
                ),
                const SizedBox(height: 20,),
                TextFieldWidget(
                    isObscure: true,
                    labelText: "Password",
                    controller: _passwordController,
                    validation: (_value) => _passwordController.text.isEmpty
                        ? "The password field is required"
                        : _passwordController.text.length < 6 ? "The password must be at least 6 characters long"
                        : null
                ), const SizedBox(height: 20,),
                TextButtonWidget(
                    onTap: ()async{
                      if (_formKey.currentState!.validate()) {
                        final response = await controller.login({
                          "email": _emailController.text.trim(),
                          "password": _passwordController.text.trim()
                        });
                        if(response.data != null){
                          final postController = Get.find<PostController>();
                          postController.getPosts();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (builder)=>HomeScreen())
                          );
                        }
                        /*
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.black38,
                                content: Text(
                                  response.error!,
                                  style: const TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              )
                          );
                        }

                         */
                      }
                    },
                    btnText: "Login"
                ),
                const SizedBox(height:20),
                LoginOrRegisterWidget(
                  firstText: "Don't have an account?",
                  secondText: "Register here",
                  onTap: (){
                    //Get.to(()=>const RegisterScreen());
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => const RegisterScreen()
                    ));
                  },
                )
              ],
            ),
          ),
        ),
    );
  }
}
