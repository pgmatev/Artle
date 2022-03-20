import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../controllers/user_controller.dart';
import '../controllers/authentication_controller.dart';
import '../main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.logout),
            onPressed: () async {
              if (await AuthenticationController().logoutUser()) {
                Get.offAll(() => const MasterWidget());
              }
            },
          )
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(),
    );
  }
}