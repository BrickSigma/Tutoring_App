import 'package:flutter/material.dart';
import 'package:tutoring_app/controllers/main_controller.dart';
import 'package:tutoring_app/views/tutor/home/notifications.dart';
import 'package:tutoring_app/views/tutor/home/settings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Notifications(),
              ),
            ),
            icon: Icon(MainController.instance.user.requests.isNotEmpty
                ? Icons.notifications_active
                : Icons.notifications),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ));
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: const Placeholder(),
    );
  }
}
