/// Entry point into UI of app, starting with the navigation bar to switch between
/// pages/views.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Main navigator between app pages (home, subjects, timetable)
class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  /// Selected page from the navigation bar.
  int _pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    /// List of all pages.
    /// Currently has empty containers to fill.
    final List<Widget> pages = <Widget>[
      Container(color: Colors.red),
      Container(color: Colors.green),
      Container(color: Colors.blue),
    ];

    final Color navColor = ElevationOverlay.applySurfaceTint(
      Theme.of(context).colorScheme.surface,
      Theme.of(context).colorScheme.surfaceTint,
      3,
    );

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarContrastEnforced: true,
        systemNavigationBarColor: navColor,
        systemNavigationBarDividerColor: navColor,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
      ),
      child: Scaffold(
        body: pages[_pageIndex],
        bottomNavigationBar: NavigationBar(
          height: 64,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: navColor,
          selectedIndex: _pageIndex,
          onDestinationSelected: (index) => setState(() {
            _pageIndex = index;
          }),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
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
