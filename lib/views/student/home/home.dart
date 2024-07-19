import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tutoring_app/controllers/main_controller.dart';
import 'package:tutoring_app/controllers/timetable_controller.dart';
import 'package:tutoring_app/views/student/home/search.dart';
import 'package:tutoring_app/views/student/home/settings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController search = TextEditingController();
  final int currentDay = DateTime.now().weekday - 1;
  List<List<Map<String, String>>> timetable = [];

  Future<int> _loadTimetable() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("users/${MainController.instance.user.uid}/timetable");
    DataSnapshot snapshot = await ref.get();
    if (snapshot.exists) {
      timetable = (snapshot.value as List)
          .map(
            (e) => e = (e as List)
                .map(
                  (e) => e = Map<String, String>.from(e as Map),
                )
                .toList(),
          )
          .toList();
    }
    if (timetable.isEmpty) {
      for (int i = 0; i < 7; i++) {
        timetable.add([
          nullTimeBlock,
        ]);
      }
    }
    await ref.set(timetable);

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    Future<int> loadTimetable = Future.delayed(
      Duration.zero,
      () => _loadTimetable(),
    );

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
      body: FutureBuilder(
          future: loadTimetable,
          builder: (context, snapshot) {
            Widget child;

            if (snapshot.hasData) {
              child = Padding(
                padding: const EdgeInsets.all(12),
                child: ListenableBuilder(
                  listenable: search,
                  builder: (context, child) {
                    return (search.text.isEmpty)
                        ? ListView(
                            children: [
                              for (Map<String, String> t
                                  in timetable[currentDay])
                                if (t["uid"]!.isNotEmpty) TimeBlockCard(t),
                            ],
                          )
                        : SearchResults(
                            search.text,
                            key: UniqueKey(),
                          );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              child = const Text("Error!");
            } else {
              child = const Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return child;
          }),
    );
  }
}

class TimeBlockCard extends StatelessWidget {
  const TimeBlockCard(this.timeblock, {super.key});

  final Map<String, String> timeblock;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Column(
        children: [
          Text("Tutor: ${timeblock["name"]}"),
          Text(timeblock["start"]!),
        ],
      ),
    );
  }
}
