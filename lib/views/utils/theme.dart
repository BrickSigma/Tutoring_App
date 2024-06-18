/// Holds the theme data for the entire app (light/dark mode) and color constants.
library;

import 'package:flutter/material.dart';

/// List of all theme modes.
const List<ThemeMode> themeModes = [
  ThemeMode.system,
  ThemeMode.light,
  ThemeMode.dark,
];

/// Font sizes.
/// =====================================

const double bodySmallSize = 16;
const double bodyMediumSize = 18;
const double bodyLargeSize = 21;
const double headlineSmallSize = 18;
const double headlineMediumSize = 21;
const double headlineLargeSize = 24;

/// =====================================

/// Light mode color scheme.
ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: const Color.fromARGB(255, 21, 47, 97),
  onPrimary: Colors.grey.shade50,
  secondary: Colors.grey.shade300,
  secondaryContainer: const Color.fromARGB(120, 136, 187, 218),
  onSecondaryContainer: const Color.fromARGB(255, 21, 47, 97),
  onSecondary: const Color.fromARGB(255, 21, 47, 97),
  error: Colors.redAccent,
  onError: Colors.grey.shade50,
  surface: Colors.grey.shade50,
  onSurface: const Color.fromARGB(255, 21, 47, 97),
);

/// Light theming on widgets.
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  textTheme: TextTheme(
    headlineLarge: const TextStyle(
      fontSize: headlineLargeSize,
    ),
    headlineMedium: TextStyle(
      decorationColor: lightColorScheme.secondary,
      fontSize: headlineMediumSize,
    ),
    headlineSmall: TextStyle(
      decorationColor: lightColorScheme.secondary,
      fontSize: headlineSmallSize,
    ),
    bodyLarge: const TextStyle(
      fontSize: bodyLargeSize,
    ),
    bodyMedium: const TextStyle(
      fontSize: bodyMediumSize,
    ),
    bodySmall: const TextStyle(
      fontSize: bodySmallSize,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      textStyle: const TextStyle(fontSize: 21),
    ),
  ),
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(shape: CircleBorder()),
);

/// Dark mode color scheme.
ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Colors.grey.shade50,
  onPrimary: Colors.grey.shade900,
  secondary: Colors.grey.shade800,
  secondaryContainer: const Color.fromARGB(120, 66, 66, 66),
  onSecondaryContainer: Colors.grey.shade50,
  onSecondary: Colors.grey.shade800,
  error: Colors.redAccent,
  onError: Colors.grey.shade50,
  surface: Colors.grey.shade900,
  onSurface: Colors.grey.shade50,
);

/// Dark theming on widgets.
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  textTheme: TextTheme(
    headlineLarge: const TextStyle(
      fontSize: headlineLargeSize,
    ),
    headlineMedium: TextStyle(
      decorationColor: darkColorScheme.secondary,
      fontSize: headlineMediumSize,
    ),
    headlineSmall: TextStyle(
      decorationColor: darkColorScheme.secondary,
      fontSize: headlineSmallSize,
    ),
    bodyLarge: const TextStyle(
      fontSize: bodyLargeSize,
    ),
    bodyMedium: const TextStyle(
      fontSize: bodyMediumSize,
    ),
    bodySmall: const TextStyle(
      fontSize: bodySmallSize,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      textStyle: const TextStyle(fontSize: 21),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    shape: CircleBorder(),
  ),
);
