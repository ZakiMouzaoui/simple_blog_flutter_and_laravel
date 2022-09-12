import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_blog_laravel/bindings/my_binding.dart';
import 'package:simple_blog_laravel/controllers/user_controller.dart';
import 'package:simple_blog_laravel/screens/loading.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: MyBinding(),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const LoadingScreen(),
    );
  }
}
