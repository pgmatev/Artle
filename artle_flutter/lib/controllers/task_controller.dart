import 'dart:convert';
import 'dart:io';

import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../controllers/authentication_controller.dart';
import '../services/task_service.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  final currentTask = Task().obs;
  var message = ''.obs;

  @override
  void onInit() {
    generateTask();
    super.onInit();
  }

  void generateTask() async {
    http.Response response = await TaskService.getNewTask();
    if (response.statusCode == 200) {
      Task task = taskFromJson(response.body);
      currentTask.value = task;
    }
    else if (response.statusCode == 401) {
      AuthenticationController().refreshAccessToken();
      generateTask();
    }
  }
}