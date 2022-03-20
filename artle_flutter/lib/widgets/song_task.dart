import 'package:artle/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/task_controller.dart';

class SongTaskWidget extends StatefulWidget {
  const SongTaskWidget({Key? key}) : super(key: key);

  @override
  _SongTaskWidgetState createState() => _SongTaskWidgetState();
}

class _SongTaskWidgetState extends State<SongTaskWidget> {
  final TaskController taskController = Get.find<TaskController>();
  final TextEditingController thoughtController = TextEditingController();
  Icon likeIcon = const Icon(Icons.favorite_border);

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  void _launchURL() async {
    String _url = taskController.currentTask.value.url!;

    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Text(
              taskController.currentTask.value.suggestion!,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
          ),
          Container(
            alignment: Alignment.topCenter,
            child: ClipRRect(
              child: GestureDetector(
                onTap: _launchURL,
                child: Image(
                  image: NetworkImage(taskController.currentTask.value.image!),
                  height: 150,
                  width: 150,
                ),
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 20),
          ),
          Text(
            taskController.currentTask.value.title!,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                color: Colors.red,
                icon: likeIcon,
                tooltip: 'Like',
                onPressed: () {
                  setState(() {
                    taskController.currentTask.value.isLiked = !taskController.currentTask.value.isLiked;
                    likeIcon = taskController.currentTask.value.isLiked ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border);
                  });
                },
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
            ]
          ),
        ],
      ),
    );
  }
}