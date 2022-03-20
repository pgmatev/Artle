import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../utils.dart';

class UserService {
  static Future<http.Response> getUserInformation() async {
    String? token = await const FlutterSecureStorage().read(key: 'accessToken');
    int userId = JwtDecoder.decode(token!)['id'];
    http.Response response = await Utils.client.get(
      Uri.parse(Utils.baseUrl + '/users/$userId'),
      headers: {
        'X-API-KEY': Utils.artleApiKey,
        'Authorization': 'Bearer ' + token,
      },
    );
    return response;
  }

  static Future<http.Response> getHistory() async {
    String? token = await const FlutterSecureStorage().read(key: 'accessToken');
    int userId = JwtDecoder.decode(token!)['id'];
    http.Response response = await Utils.client.get(
      Uri.parse(Utils.baseUrl + '/users/$userId/history'),
      headers: {
        'X-API-KEY': Utils.artleApiKey,
        'Authorization': 'Bearer ' + token,
      },
    );
    return response;
  }
}