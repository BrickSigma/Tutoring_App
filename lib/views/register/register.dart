import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({required ValueNotifier pageIndex, super.key})
      : _pageIndex = pageIndex;

  final ValueNotifier _pageIndex;

  static const int index = 1;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final usernameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final passwordConfirmController = TextEditingController();

  bool isTutor = false;

  void registerUser() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        passwordConfirmController.text.isNotEmpty &&
        usernameController.text.isNotEmpty &&
        passwordController.text == passwordConfirmController.text &&
        EmailValidator.validate(emailController.text)) {
      try {
        UserCredential user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        await FirebaseDatabase.instance.ref().update({
          "users/${user.user!.uid}": {
            "name": usernameController.text,
            "tutor": isTutor
          }
        });
      } on FirebaseAuthException catch (e) {
        print(e.code);
      }
    } else {
      print("Invalid credentials!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register New Account"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => widget._pageIndex.value = 0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(hintText: "Full Name"),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(hintText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 25),
            TextField(
              controller: passwordConfirmController,
              decoration: const InputDecoration(hintText: "Confirm Password"),
              obscureText: true,
            ),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: () => setState(() {
                isTutor = !isTutor;
              }),
              child: Row(
                children: [
                  Checkbox(
                    value: isTutor,
                    onChanged: (value) => setState(() {
                      isTutor = value ?? false;
                    }),
                  ),
                  const Text("Are you a tutor?"),
                ],
              ),
            ),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: registerUser,
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
