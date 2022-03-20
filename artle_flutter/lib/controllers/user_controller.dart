import 'dart:convert';
import 'dart:io';


import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../controllers/authentication_controller.dart';
import '../models/user.dart';
import '../models/history.dart';
import '../services/user_service.dart';

class UserController extends GetxController {
  final currentUser = User().obs;
  final currentUserHistory = <History>[].obs;
  var message = ''.obs;

  @override
  void onInit() {
    getUserInformation();
    getHistory();
    super.onInit();
  }

  void getUserInformation() async {
    http.Response response = await UserService.getUserInformation();
    if (response.statusCode == 200) {
      User user = userFromJson(response.body);
      currentUser.value = user;
    }
    else if (response.statusCode == 401) {
      AuthenticationController().refreshAccessToken();
      getUserInformation();
    }
  }

  void getHistory() async {
    http.Response response = await UserService.getHistory();
    if (response.statusCode == 200) {
      List<History> history = historyFromJson(response.body);
      history.sort((a, b) => b.id!.compareTo(a.id!));
      currentUserHistory.assignAll(history);
    }
    else if (response.statusCode == 401) {
      AuthenticationController().refreshAccessToken();
      getUserInformation();
    }
  }
}