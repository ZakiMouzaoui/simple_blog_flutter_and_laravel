import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_blog_laravel/controllers/user_controller.dart';
import 'package:simple_blog_laravel/screens/login_screen.dart';
import 'package:simple_blog_laravel/widgets/login_or_register_widget.dart';
import 'package:simple_blog_laravel/widgets/text_button_widget.dart';
import 'package:simple_blog_laravel/widgets/text_field_widget.dart';

import '../utils.dart';
import 'home_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    final controller = Get.find<UserController>();

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFieldWidget(
                        labelText: "Name",
                        controller: _nameController,
                        validation: (_value) => _value!.isEmpty
                            ? "The name field is required"
                            : null
                    ),
                    const SizedBox(height: 20,),
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
                        onTap: () async{
                          if (_formKey.currentState!.validate()) {
                            final response = await controller.register({
                              "name": _nameController.text.trim(),
                              "email": _emailController.text.trim(),
                              "password": _passwordController.text.trim(),
                              'password_confirmation': _passwordController.text.trim()
                            });

                            if(response.data != null){
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (builder)=>HomeScreen())
                              );
                            }
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
                          }
                        },
                        btnText: "Register"
                    ),
                    const SizedBox(height:20),
                    LoginOrRegisterWidget(
                      firstText: "Already have an account?",
                      secondText: "Login here",
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => const LoginScreen()
                        ));

                        //Get.to(()=>const LoginScreen());
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
