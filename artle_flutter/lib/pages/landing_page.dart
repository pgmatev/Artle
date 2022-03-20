import 'package:artle/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/pages/login_page.dart';
import '/pages/register_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Welcome to ARtle',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    primary: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Text(
                    'Log in',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => LoginPage());
                  }),
                const SizedBox(
                  height: 16,
                ),
                const Text('or'),
                TextButton(
                  onPressed: () {
                    Get.to(() => RegisterPage());
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  )),
                const Text('to use all of the apps features'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}