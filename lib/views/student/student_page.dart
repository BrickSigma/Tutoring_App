/// Entry point into UI of app, starting with the navigation bar to switch between
/// pages/views.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutoring_app/views/student/home/home.dart';
import 'package:tutoring_app/views/student/todo/todo_list_page.dart';

/// Main navigator between app pages (home, todo list, timetable)
class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  /// Selected page from the navigation bar.
  int _pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    /// List of all pages.
    /// Currently has empty containers to fill.
    final List<Widget> pages = <Widget>[
      const ToDoListPage(),
      const Home(),
      Container(color: Colors.blue),
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
      child: Scaffold(
        body: pages[_pageIndex],
        // Navigation bar used to switch between the pages.
        bottomNavigationBar: NavigationBar(
          height: 64,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: navColor,
          selectedIndex: _pageIndex,
          // Set the page index when a navigation item is selected.
          onDestinationSelected: (index) => setState(() {
            _pageIndex = index;
          }),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          // List of pages/tabs.
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.list),
              label: "Todo",
            ),
            NavigationDestination(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month),
              label: "Timetable",
            ),
          ],
        ),
      ),
    );
  }
}
