import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

// import '../controllers/user_controller.dart';
import '../models/user.dart';
import '../services/authentication_service.dart';

class AuthenticationController extends GetxController{
  var message = ''.obs;

  Future<bool> loginUser(String name, String password) async {
    http.Response response = await AuthenticationService.loginUser(name, password);
    Map<String, dynamic> responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      String accessToken = responseBody['access_token'];
      await const FlutterSecureStorage().write(key: 'accessToken', value: accessToken);
      return true;
    }
    else {
      message.value = responseBody['message'];
      return false;
    }
  }

  void registerUser(User user) async {
    http.Response response = await AuthenticationService.registerUser(user);
    Map<String, dynamic> responseBody = json.decode(response.body);
    message.value = responseBody['message'];
  }

  Future<bool> refreshAccessToken() async {
    String? accessToken = await const FlutterSecureStorage().read(key: 'accessToken');
    if (accessToken != null) {
      if (JwtDecoder.isExpired(accessToken)) {
        http.Response response = await AuthenticationService.refreshAccessToken(
            accessToken);
        Map<String, dynamic> responseBody = json.decode(response.body);

        if (response.statusCode == 200) {
          String newAccessToken = responseBody['access_token'];
          await const FlutterSecureStorage().write(
              key: 'accessToken', value: newAccessToken);
          return true;
        }
        else {
          logoutUser();
          return false;
        }
      }
    }
    return false;
  }

  Future<bool> logoutUser() async {
    // UserController().dispose();
    await FlutterSecureStorage().delete(key: 'accessToken');
    return true;
  }
}