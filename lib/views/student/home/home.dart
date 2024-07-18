import 'package:flutter/material.dart';
import 'package:tutoring_app/views/student/home/search.dart';
import 'package:tutoring_app/views/student/home/settings.dart';

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
        title: SizedBox(
          height: 50,
          child: TextField(
            controller: search,
            decoration: const InputDecoration(hintText: "Find a tutor"),
          ),
        ),
        actions: [
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
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListenableBuilder(
          listenable: search,
          builder: (context, child) {
            return (search.text.isEmpty)
                ? const Text("Content")
                : SearchResults(
                    search.text,
                    key: UniqueKey(),
                  );
          },
        ),
      ),
    );
  }
}
