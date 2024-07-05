/// Entry point into UI of app, starting with the navigation bar to switch between
/// pages/views.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutoring_app/views/forgot_password/forgot_password.dart';
import 'package:tutoring_app/views/login/login.dart';
import 'package:tutoring_app/views/register/register.dart';

/// Main navigator between app pages (home, todo list, timetable)
class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  /// Selected page from the navigation bar.
  final ValueNotifier<int> _pageIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    /// List of all pages.
    final List<Widget> pages = <Widget>[
      Login(pageIndex: _pageIndex), // Login
      Register(pageIndex: _pageIndex), // Register
      ForgotPassword(pageIndex: _pageIndex), // Forgot password
      Container(color: Colors.amber), // Tutor
      Container(color: Colors.pink), // Student
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
        listenable: _pageIndex,
        builder: (context, child) => pages[_pageIndex.value],
      ),
    );
  }
}
