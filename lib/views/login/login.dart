import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tutoring_app/main.dart';
import 'package:tutoring_app/views/forgot_password/forgot_password.dart';
import 'package:tutoring_app/views/register/register.dart';

class Login extends StatefulWidget {
  const Login({required ValueNotifier pageIndex, super.key})
      : _pageIndex = pageIndex;

  final ValueNotifier _pageIndex;

  static const int index = 0;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void login(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        UserCredential credentials = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        await FirebaseDatabase.instance
            .ref("users/${credentials.user!.uid}")
            .keepSynced(true);
        if (context.mounted) {
          App.restartApp(context);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        String errorCode = "";
        switch (e.code) {
          case "user-disabled":
            errorCode = "User disabled";
            break;
          case "user-not-found":
            errorCode = "User not found";
            break;
          case "wrong-password":
            errorCode = "Wrong password";
            break;
          case "invalid-email":
            errorCode = "Invalid email";
            break;
          case "invalid-credential":
            errorCode = "Invalid credential";
            break;
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Could Not Login!"),
            content: Text(errorCode),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Okay"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: Form(
          key: _formKey,
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
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(hintText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "No email entered!";
                  } else if (!EmailValidator.validate(value)) {
                    return "Invalid email!";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(hintText: "Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "No password enetered!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => widget._pageIndex.value = ForgotPassword.index,
                    child: const Text(
                      "Forgot Password?",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => login(context),
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
                onTap: () => widget._pageIndex.value = Register.index,
                child: const Text(
                  "Don't have an account ?",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
