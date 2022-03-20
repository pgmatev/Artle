import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../main.dart';
import '../widgets/song_task.dart';
import '../widgets/movie_task.dart';
import '../widgets/quote_task.dart';
import '../widgets/rhyme_task.dart';
import '../widgets/drawing_task.dart';
import '../controllers/task_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage>, WidgetsBindingObserver{
  final TaskController taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();

    taskController.generateTask();
    print("initn");
    print(taskController.currentTask.value.model);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    super.setState(fn);
    // taskController.generateTask();
    print("state changed home");
    print(taskController.currentTask.value.model);
  }

  Widget? determineWidget() {
    print(taskController.currentTask.value.model);
    if (taskController.currentTask.value.model == "Music") {
      return const SongTaskWidget();
    }
    else if (taskController.currentTask.value.model == "Quote") {
      return const QuoteTaskWidget();
    }
    else if (taskController.currentTask.value.model == "Movie") {
      return const MovieTaskWidget();
    }
    else if (taskController.currentTask.value.model == "Drawing") {
      return const DrawingTaskWidget();
    }
    else if (taskController.currentTask.value.model == "Rhyme") {
      return const RhymeTaskWidget();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        actions: [
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                primary: Theme.of(context).colorScheme.secondary,
              ),
              child: Text(
                'Skip',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                taskController.generateTask();
                print(taskController.currentTask.value.model);
              },
            ),
            margin: const EdgeInsets.only(right: 10, top: 10),
          ),
        ],
      ),
      body: Obx(() {return determineWidget()!;}),
    );
  }

  @override
  bool get wantKeepAlive => true;
}