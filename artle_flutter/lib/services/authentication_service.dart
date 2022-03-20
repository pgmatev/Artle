import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../utils.dart';

class AuthenticationService {
  static Future<http.Response> loginUser(String name, String password) async {
    http.Response response = await Utils.client.post(
      Uri.parse(Utils.baseUrl + 'auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'X-API-KEY': Utils.artleApiKey
      },
      body: json.encode({"username": name, "password": password}),
    );
    return response;
  }

  static Future<http.Response> registerUser(User user) async {
    http.Response response = await Utils.client.post(
      Uri.parse(Utils.baseUrl + 'auth/register'),
      headers: {
        'Content-Type': 'application/json',
        'X-API-KEY': Utils.artleApiKey
      },
      body: userToJson(user),
    );
    return response;
  }

  static Future<http.Response> refreshAccessToken(String accessToken) async {
    http.Response response = await Utils.client.get(
      Uri.parse(Utils.baseUrl + 'auth/refresh'),
      headers: {
        'X-API-KEY': Utils.artleApiKey,
        'Authorization': 'Bearer $accessToken',
      },
    );
    return response;
  }
}