import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'pages/history_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/landing_page.dart';
import 'widgets/nav_bar.dart';
// import 'controllers/authentication_controller.dart';


void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  final ThemeData theme = ThemeData();

  runApp(GetMaterialApp(
    theme: theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        background: const Color.fromRGBO(250, 249, 246, 1),
        primary: Colors.black,
        secondary: const Color.fromRGBO(255, 199, 0, 1)
      ),
    ),
    debugShowCheckedModeBanner: false,
    home: const MasterWidget(),
  ));
}

class MasterWidget extends StatefulWidget {
  const MasterWidget({Key? key}) : super(key: key);

  @override
  MasterWidgetState createState() => MasterWidgetState();
}

class MasterWidgetState extends State<MasterWidget> {
  MyBottomNavigationBar navigationBar = MyBottomNavigationBar();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> checkLoggedIn() async {
    bool isLogged;
    await const FlutterSecureStorage().read(key: 'accessToken') == null
        ? isLogged = false
        : isLogged = true;
    // return isLogged;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.background,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: FutureBuilder(
        future: Future.wait([
          checkLoggedIn(),
          // AuthenticationController().refreshAccessToken()
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Scaffold(
                body: PageView(
                  controller: navigationBar.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    snapshot.data![0] ? const HistoryPage() : const LandingPage(),
                    snapshot.data![0] ? const HomePage() : const LandingPage(),
                    snapshot.data![0] ? const ProfilePage() : const LandingPage(),
                  ],
                ),
                bottomNavigationBar: snapshot.data![0] ? navigationBar : null,
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Container(
                  child: Text(
                    snapshot.error.toString(),
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}