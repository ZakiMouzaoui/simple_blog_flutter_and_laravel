import 'dart:io';

import 'package:get/get.dart';
import 'package:simple_blog_laravel/models/api_response.dart';
import 'package:simple_blog_laravel/services/post_service.dart';
import 'package:simple_blog_laravel/utils.dart';

class PostController extends GetxController{
  var posts = [].obs;
  final service = PostService();
  var currentPageIndex = 0.obs;
  var imageFile = File("").obs;

  @override
  void onInit() {
    super.onInit();
    getPosts();

  }

  Future<void> getPosts() async{
    final apiResponse = await service.getPosts();
    if(apiResponse.data != null){
      posts.value = apiResponse.data["posts"];
      update();
    }
    resetFile();
  }

  Future<ApiResponse> addPost(String body, File? image) async{
    final apiResponse = await service.addPost(body, getStringImage(image?.path == "" ? null : image));

    if(apiResponse.data != null){
      getPosts();
    }

    return apiResponse;
  }

  Future<ApiResponse> editPost(int id, String body, File? image) async{
    final apiResponse = await service.editPost(id, body, getStringImage(image?.path == "" ? null : image));

    if(apiResponse.data != null){
      getPosts();
    }

    return apiResponse;
  }

  Future<ApiResponse> deletePost(int id) async{
    ApiResponse apiResponse = await service.deletePost(id);
    getPosts();
    return apiResponse;
  }

  void likeOrUnlikePost(int id){
    service.likeOrUnlikePost(id);
    getPosts();
  }

  void changePageIndex(newIndex){
    currentPageIndex.value = newIndex;
    update();
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
