import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutoring_app/views/forgot_password/forgot_password.dart';
import 'package:tutoring_app/views/register/register.dart';

class Login extends StatelessWidget {
  Login({required ValueNotifier pageIndex, super.key}) : _pageIndex = pageIndex;

  final ValueNotifier _pageIndex;

  static const int index = 0;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    try {
      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          EmailValidator.validate(emailController.text)) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      } else {
        print("Invalid email!");
      }
    } on FirebaseAuthException catch (e) {
      print("AUTH ERROR: ${e.code}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_person,
              size: 100,
            ),
            const SizedBox(height: 50),
            const Text("Welcome"),
            const SizedBox(height: 25),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: "Username"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(hintText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => _pageIndex.value = ForgotPassword.index,
                  child: const Text(
                    "Forgot Password?",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: login,
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    "Log in",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _pageIndex.value = Register.index,
              child: const Text(
                "Don't have an account ?",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
