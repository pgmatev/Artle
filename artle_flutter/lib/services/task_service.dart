import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../utils.dart';

class TaskService {
  static Future<http.Response> getNewTask() async {
    String? token = await const FlutterSecureStorage().read(key: 'accessToken');

    http.Response response = await Utils.client.get(
      Uri.parse(Utils.baseUrl + 'tasks/generate'),
      headers: {
        'X-API-KEY': Utils.artleApiKey,
        'Authorization': 'Bearer ' + token!,
      },
    );
    return response;
  }
}