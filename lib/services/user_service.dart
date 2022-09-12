import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_blog_laravel/constant.dart';
import 'package:simple_blog_laravel/models/api_response.dart';

class UserService {
  Future<ApiResponse> login(Map credentials) async {
    final apiResponse = ApiResponse();

    final response = await http.post(
        Uri.parse(loginURL),
        body: credentials,
        headers: {
          "Accept": "application/json"
        }
    );

    try {
      switch (response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body);
          _save(apiResponse.data["token"], apiResponse.data["user"]["id"]);
          break;
        case 422:
          final errors = jsonDecode(response.body)["errors"];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          break;
        case 403:
          apiResponse.error = jsonDecode(response.body)["message"];
          break;
        default:
          apiResponse.error = somethingWentWrong;
      }
    }
    catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  Future<ApiResponse> register(Map credentials) async {
    final apiResponse = ApiResponse();

    final response = await http.post(
        Uri.parse(registerURL),
        body: credentials,
        headers: {
          "Accept": "application/json"
        }
    );

    try {
      switch (response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body);
          _save(apiResponse.data["token"], apiResponse.data["user"]["id"]);
          break;
        case 422:
          final errors = jsonDecode(response.body)["errors"];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          break;
        case 403:
          apiResponse.error = jsonDecode(response.body)["message"];
          break;
        default:
          apiResponse.error = somethingWentWrong;
      }
    }
    catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  Future<ApiResponse> getUserDetail() async {
    final apiResponse = ApiResponse();
    String token = await getToken();

    try {
      final response = await http.get(
          Uri.parse(userURL),
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          });

      switch (response.statusCode) {
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
    catch (e) {
      apiResponse.error = serverError;
    }

    return apiResponse;
  }

  Future<ApiResponse> updateProfile(String name, String? image) async {
    final apiResponse = ApiResponse();
    String token = await getToken();

    try {
      final response = await http.put(
          Uri.parse(userURL),
          body: image != null
          ? {
            "name": name,
            "image": image
          } : {
            "name": name
          },
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          });

      switch (response.statusCode) {
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
    catch (e) {
      apiResponse.error = serverError;
    }

    return apiResponse;
  }

  Future<bool> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.remove("token");
  }

  Future<String> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("token") ?? "";
  }

  Future<int> getId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt("user_id") ?? 0;
  }

  Future<void> _save(token, id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", token ?? "");
    preferences.setInt("user_id", id ?? 0);
  }
}
