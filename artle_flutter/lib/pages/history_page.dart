import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../controllers/user_controller.dart';
// import '../controllers/authentication_controller.dart';
import '../main.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'History',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 20.0, right: 22.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                'DATE',
                style: TextStyle(color: Colors.black26),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}