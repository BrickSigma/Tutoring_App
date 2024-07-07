import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutoring_app/controllers/main_controller.dart';
import 'package:tutoring_app/firebase_options.dart';
import 'package:tutoring_app/views/navigator_page.dart';
import 'package:tutoring_app/views/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseDatabase.instance.setPersistenceEnabled(true);

  // Disable screen rotation.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Start the app.
  runApp(const App());
}

/// Main entry point to the app.
///
/// Loads the app data from disk before starting the UI (`/views/navigator_page.dart`)
class App extends StatefulWidget {
  const App({super.key});

  /// Used to restart the app programatically.
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_AppState>()!.restartApp();
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// Controller for the main app.
  MainController controller = MainController.instance;

  /// Used for handling the app restart.
  Key key = UniqueKey();

  /// Theme mode settings
  final List<ThemeMode> _themeModes = [
    ThemeMode.system,
    ThemeMode.light,
    ThemeMode.dark
  ];

  /// Used to restart the app programatically if needed.
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Function used to load data from the disk/main controller.
    Future<int> loadData = Future<int>.delayed(
      Duration.zero,
      () async => await controller.loadData(),
    );

    return ListenableBuilder(
      key: key,
      listenable: controller,
      builder: (context, child) => MaterialApp(
        title: "Tutoring App",
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: _themeModes[controller.themeMode],
        // Using a FutureBuilder to load data from disk before starting the main UI.
        home: FutureBuilder<int>(
          future: loadData,
          builder: (context, snapshot) {
            Widget child;
            if (snapshot.hasData) {
              // Load the navigator page once the app data is loaded.
              child = NavigatorPage(MainController.instance.pageIndex);
            } else if (snapshot.hasError) {
              // If there was an error in loading the app data, show an error screen.
              child =
                  const Center(child: Text("ERROR: Could not load app data!"));
            } else {
              // Show a loading screen as the data is being loaded.
              child = const Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator()),
              );
            }

            return child;
          },
        ),
      ),
    );
  }
}
