import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutoring_app/controllers/main_controller.dart';
import 'package:tutoring_app/views/navigator_page.dart';
import 'package:tutoring_app/views/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Disable screen rotation.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_AppState>()!.restartApp();
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// Controller for the main app.
  MainController controller = MainController.instance;

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
        home: FutureBuilder<int>(
          future: loadData,
          builder: (context, snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child = const NavigatorPage();
            } else if (snapshot.hasError) {
              child =
                  const Center(child: Text("ERROR: Could not load app data!"));
            } else {
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
