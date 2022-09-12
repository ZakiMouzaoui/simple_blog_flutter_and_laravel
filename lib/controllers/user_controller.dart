import 'dart:io';

import 'package:get/get.dart';
import 'package:simple_blog_laravel/models/api_response.dart';
import 'package:simple_blog_laravel/screens/home_screen.dart';
import 'package:simple_blog_laravel/services/user_service.dart';
import 'package:simple_blog_laravel/utils.dart';
import 'package:simple_blog_laravel/widgets/show_snackbar.dart';

import '../models/user.dart';

class UserController extends GetxController{
  var isLoading = false.obs;
  var user = User().obs;
  var imageFile = File("").obs;

  UserService service = UserService();

  @override
  onInit(){
    getDetails();
    super.onInit();
  }

  Future<ApiResponse> register(Map credentials) async{
    isLoading.value = true;
    update();

    final apiResponse = await service.register(credentials);

    isLoading.value = false;
    update();

    if(apiResponse.error == null){
      user.value = User.fromJson(apiResponse.data["user"]);
      update();
    }

    return apiResponse;
  }

  Future<ApiResponse> login(Map credentials) async{
    ApiResponse apiResponse = ApiResponse();
    isLoading.value = true;
    update();

    apiResponse = await service.login(credentials);
    isLoading.value = false;
    update();

    if(apiResponse.error != null){
      Get.closeAllSnackbars();
      showSnackBar("Login Status", apiResponse.error);
    }
    else{
      user.value = User.fromJson(apiResponse.data["user"]);
      update();
      Get.to(()=>HomeScreen());
    }

    return apiResponse;
  }

  Future<ApiResponse> getDetails() async{
    final apiResponse = await service.getUserDetail();
    if(apiResponse.error == null){
      user.value = User.fromJson(apiResponse.data["user"]);
    }

    update();

    return apiResponse;
  }

  Future<ApiResponse> updateProfile(String name, File? image) async{
    ApiResponse apiResponse = ApiResponse();

    apiResponse = await service.updateProfile(name, getStringImage(image?.path == "" ? null : image));

    user.value=User.fromJson(apiResponse.data["user"]);
    resetFile();
    update();

    return apiResponse;
  }

  void logout(){
    service.logout();
  }

  void getImage(_pickedImage){
    imageFile.value= File(_pickedImage.path);
    update();
  }

  void resetFile(){
    imageFile.value=File("");
    update();
  }
}
