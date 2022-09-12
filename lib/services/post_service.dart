import 'dart:convert';

import 'package:simple_blog_laravel/constant.dart';
import 'package:simple_blog_laravel/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:simple_blog_laravel/services/user_service.dart';

class PostService{
  UserService userService = UserService();

  Future<ApiResponse> getPosts() async{
    ApiResponse apiResponse = ApiResponse();
    final token = await userService.getToken();

    final response = await http.get(
      Uri.parse(postURL),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      }
    );

    try{
      switch (response.statusCode){
        case 200:
          apiResponse.data = jsonDecode(response.body);
          break;
        case 422:
          final errors = jsonDecode(response.body)["errors"];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
      }
    }
    catch(e){
      apiResponse.error = serverError;
    }

    //print(apiResponse.data);

    return apiResponse;
  }

  Future<ApiResponse> addPost(String body, String? image) async{
    ApiResponse apiResponse = ApiResponse();
    final token = await userService.getToken();

    final response = await http.post(
        Uri.parse(postURL),
        body: image != null ? {
          "body": body,
          "image": image
        } : {
          "body": body
        },
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }
    );

    try{
      switch (response.statusCode){
        case 200:
          apiResponse.data = jsonDecode(response.body);
          break;
        case 422:
          final errors = jsonDecode(response.body)["errors"];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
      }
    }
    catch(e){
      apiResponse.error = serverError;
    }

    return apiResponse;
  }

  Future<ApiResponse> editPost(int id, String body, String? image) async{
    ApiResponse apiResponse = ApiResponse();
    final token = await userService.getToken();

    final response = await http.put(
        Uri.parse("$postURL/$id"),
        body: image != null ? {
          "body": body,
          "image": image
        } : {
          "body": body
        },
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }
    );

    try{
      switch (response.statusCode){
        case 200:
          apiResponse.data = jsonDecode(response.body);
          break;
        case 422:
          final errors = jsonDecode(response.body)["errors"];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
      }
    }
    catch(e){
      apiResponse.error = serverError;
    }

    return apiResponse;
  }

  Future<ApiResponse> deletePost(int id) async{
    ApiResponse apiResponse = ApiResponse();
    final token = await userService.getToken();

    final response = await http.delete(
        Uri.parse(postURL+"/$id"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }
    );

    try{
      switch (response.statusCode){
        case 200:
          apiResponse.data = jsonDecode(response.body);
          break;
        case 422:
          final errors = jsonDecode(response.body)["errors"];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
      }
    }
    catch(e){
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  Future<ApiResponse> likeOrUnlikePost(int id) async {
    ApiResponse apiResponse = ApiResponse();
    final token = await userService.getToken();

    final response = await http.post(
        Uri.parse("$postURL/$id/likes"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }
    );

    try{
      switch (response.statusCode){
        case 200:
          apiResponse.data = jsonDecode(response.body);
          break;
        case 422:
          final errors = jsonDecode(response.body)["errors"];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
      }
    }
    catch(e){
      apiResponse.error = serverError;
    }
    return apiResponse;
  }
}
