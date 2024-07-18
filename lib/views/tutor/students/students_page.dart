import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tutoring_app/controllers/main_controller.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  List<Widget> studentsList = [];
  Key key = UniqueKey();

  Future<int> _loadStudents() async {
    studentsList.clear();
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("users/${MainController.instance.user.uid}/students");
    DataSnapshot snapshot = await ref.get();
    if (snapshot.exists) {
      List<String> studentsIds = List.from((snapshot.value ?? []) as List);
      for (String id in studentsIds) {
        ref = FirebaseDatabase.instance.ref("users/$id/name");
        snapshot = await ref.get();
        if (snapshot.exists) {
          studentsList.add(
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                snapshot.value.toString(),
              ),
            ),
          );
        }
      }
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    Future<int> loadStudents = Future.delayed(
      Duration.zero,
      () => _loadStudents(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Students"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder(
          key: key,
          future: loadStudents,
          builder: (context, snapshot) {
            Widget child;

            if (snapshot.hasData) {
              child = ListView.separated(
                  itemBuilder: (context, index) => studentsList[index],
                  separatorBuilder: (context, index) => const Divider(
                        height: 0,
                        thickness: 2,
                      ),
                  itemCount: studentsList.length);
            } else if (snapshot.hasError) {
              child = const Text("Error loading students!");
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
          },
        ),
      ),
    );
  }
}
