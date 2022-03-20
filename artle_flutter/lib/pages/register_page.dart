import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/authentication_controller.dart';
import '../models/user.dart';

final inputFieldBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

class RegisterPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final AuthenticationController authenticationController =
  Get.put(AuthenticationController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
  TextEditingController();

  RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
        title: Text(
          "Register",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        child: Column(
          children: <Widget>[
            Obx(() {
              return Text(
                authenticationController.message.value,
                style: const TextStyle(color: Colors.red),
              );
            }),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: inputFieldBoxDecoration,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.account_circle,
                          color: Colors.black,
                        ),
                        hintText: "Enter your email",
                        labelText: "Email*",
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email!';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: inputFieldBoxDecoration,
                    child: TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.account_circle,
                          color: Colors.black,
                        ),
                        hintText: "Enter your username",
                        labelText: "Username*",
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username!';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: inputFieldBoxDecoration,
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                        hintText: "Enter your password",
                        labelText: "Password*",
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password!';
                        }
                        if (value.length < 5) {
                          return 'Password too short!';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: inputFieldBoxDecoration,
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordConfirmController,
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                        hintText: "Enter your password again",
                        labelText: "Confirm password*",
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password again!';
                        } else if (value != passwordController.text) {
                          return 'Passwords don' 't match';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 32,
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
                      "Register",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final email = emailController.text;
                        final username = usernameController.text;
                        final password = passwordController.text;
                        final User user = User(
                          email: email,
                          username: username,
                          password: password,
                        );
                        authenticationController.registerUser(user);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}