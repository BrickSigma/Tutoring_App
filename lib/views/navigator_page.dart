/// Entry point into UI of app, starting with the navigation bar to switch between
/// pages/views.
library;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutoring_app/views/forgot_password/forgot_password.dart';
import 'package:tutoring_app/views/login/login.dart';
import 'package:tutoring_app/views/register/register.dart';
import 'package:tutoring_app/views/student/student_page.dart';

/// Main navigator between app pages (home, todo list, timetable)
class NavigatorPage extends StatefulWidget {
  const NavigatorPage(this.pageIndex, {super.key});

  /// Selected page from the navigation bar.
  final ValueNotifier<int> pageIndex;

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  /// Check if the user is already signed into the app.
  void setup() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      widget.pageIndex.value = Login.index;
    } else {
      final snapshot =
          await FirebaseDatabase.instance.ref("users/${user.uid}").get();
      if (snapshot.exists) {
        if ((snapshot.value as Map)["tutor"]) {
          widget.pageIndex.value = 3;
        } else {
          widget.pageIndex.value = 4;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    setup();

    /// List of all pages.
    final List<Widget> pages = <Widget>[
      Login(pageIndex: widget.pageIndex), // Login
      Register(pageIndex: widget.pageIndex), // Register
      ForgotPassword(pageIndex: widget.pageIndex), // Forgot password
      Container(color: Colors.amber), // Tutor
      const StudentPage(), // Student
    ];

    // Colors used for system UI.
    final Color navColor = ElevationOverlay.applySurfaceTint(
      Theme.of(context).colorScheme.surface,
      Theme.of(context).colorScheme.surfaceTint,
      3,
    );

    return AnnotatedRegion(
      // Set the system UI color scheme to match the app.
      value: SystemUiOverlayStyle(
        systemNavigationBarContrastEnforced: true,
        systemNavigationBarColor: navColor,
        systemNavigationBarDividerColor: navColor,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
      ),

      // Main app UI entry point.
      child: ListenableBuilder(
        listenable: widget.pageIndex,
        builder: (context, child) => pages[widget.pageIndex.value],
      ),
    );
  }
}
