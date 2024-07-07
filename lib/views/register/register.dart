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
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final passwordConfirmController = TextEditingController();

  bool isTutor = false;

  void registerUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        await FirebaseDatabase.instance.ref().update({
          "users/${credential.user!.uid}": {
            "name": usernameController.text,
            "tutor": isTutor
          }
        });
        await FirebaseDatabase.instance
            .ref("users/${credential.user!.uid}")
            .keepSynced(true);
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("User created!"),
              content: const Text("Go back to login..."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Okay"),
                ),
              ],
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          String errorCode = "";
          switch (e.code) {
            case "email-already-in-use":
              errorCode = "Email already in use";
              break;
            case "operation-not-allowed":
              errorCode = "Operation not allowed";
              break;
            case "weak-password":
              errorCode = "Weak password";
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
              title: const Text("Could Create New Account!"),
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(hintText: "Full Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required field!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(hintText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required field!";
                  } else if (!EmailValidator.validate(value)) {
                    return "Invalid email!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(hintText: "Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required field!";
                  } else if (value.length < 6) {
                    return "Must be more than 6 letters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: passwordConfirmController,
                decoration: const InputDecoration(hintText: "Confirm Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required field!";
                  } else if (value != passwordController.text) {
                    return "Passwords do not match!";
                  }
                  return null;
                },
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
                onTap: () => registerUser(context),
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
      ),
    );
  }
}
