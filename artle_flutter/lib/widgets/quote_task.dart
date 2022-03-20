import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/task_controller.dart';
import '../main.dart';

class QuoteTaskWidget extends StatefulWidget {
  const QuoteTaskWidget({Key? key}) : super(key: key);

  @override
  _QuoteTaskWidgetState createState() => _QuoteTaskWidgetState();
}

class _QuoteTaskWidgetState extends State<QuoteTaskWidget> {
  final TaskController taskController = Get.find<TaskController>();
  final TextEditingController thoughtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        taskController.currentTask.value.url!,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}