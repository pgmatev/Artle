import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/task_controller.dart';
import '../main.dart';

class RhymeTaskWidget extends StatefulWidget {
  const RhymeTaskWidget({Key? key}) : super(key: key);

  @override
  _RhymeTaskWidgetState createState() => _RhymeTaskWidgetState();
}

class _RhymeTaskWidgetState extends State<RhymeTaskWidget> {
  final TaskController taskController = Get.find<TaskController>();
  final TextEditingController thoughtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text(
            "Римувай: ${taskController.currentTask.value.suggestion!}",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: TextField(
            controller: thoughtController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter text!',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.save),
          tooltip: 'Save',
          onPressed: () async {
            taskController.currentTask.value.thought = thoughtController.text;
            bool isSaved = await taskController.saveTask(taskController.currentTask.value);
            print(isSaved);
            if (isSaved) {
              Get.offAll(() => const MasterWidget());
            }
          },
        ),
      ],
    );
  }
}