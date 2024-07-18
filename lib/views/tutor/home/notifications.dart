import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tutoring_app/controllers/main_controller.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<Widget> requestCards = [];
  Key key = UniqueKey();

  void update() => setState(() => key = UniqueKey());

  Future<int> _loadNotifications() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("users/${MainController.instance.user.uid}/requests");
    requestCards.clear();

    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      List<String> requests = List.from((snapshot.value ?? []) as List);

      for (String request in requests) {
        ref = FirebaseDatabase.instance.ref("users/$request/name");
        snapshot = await ref.get();
        String name = "";
        if (snapshot.exists) {
          name = snapshot.value.toString();
        }
        requestCards.add(
          RequestCard(request, name, update),
        );
      }
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    Future<int> loadNotifications = Future<int>.delayed(
      Duration.zero,
      () => _loadNotifications(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        key: key,
        future: loadNotifications,
        builder: (context, snapshot) {
          Widget child;

          if (snapshot.hasData) {
            child = ListView(
              children: requestCards,
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
        },
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  const RequestCard(this.uid, this.name, this.update, {super.key});

  final String uid;
  final String name;
  final Function() update;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.secondaryContainer),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name),
              const SizedBox(height: 12),
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      /// On accepting the request, move the student id from the
                      /// requests list to the students list and also add the tutor's
                      /// ID to the student's account.
                      DatabaseReference ref = FirebaseDatabase.instance.ref(
                          "users/${MainController.instance.user.uid}/requests");
                      DataSnapshot snapshot = await ref.get();
                      if (snapshot.exists) {
                        List<String> requests =
                            List.from((snapshot.value ?? []) as List);
                        requests.remove(uid);
                        MainController.instance.user.requests.remove(uid);
                        await ref.set(
                            requests); // Remove the student ID from the requests list
                      }

                      ref = FirebaseDatabase.instance.ref(
                          "users/${MainController.instance.user.uid}/students");
                      snapshot = await ref.get();
                      List<String> students = [];
                      if (snapshot.exists) {
                        students = List.from((snapshot.value ?? []) as List);
                      }
                      students.add(uid);
                      MainController.instance.user.students = students;
                      await ref.set(
                          students); // Add the student ID to the students list

                      ref = FirebaseDatabase.instance.ref("users/$uid/tutors");
                      snapshot = await ref.get();
                      List<String> tutors = [];
                      if (snapshot.exists) {
                        tutors = List.from((snapshot.value ?? []) as List);
                      }
                      tutors.add(uid);
                      await ref.set(
                          tutors); // Add the student ID to the students list
                      update();
                    },
                    child: const Text("Accept"),
                  ),
                  TextButton(
                    onPressed: () async {
                      /// On declining the request, simply remove the student ID
                      /// from the requests list for the tutor.
                      DatabaseReference ref = FirebaseDatabase.instance.ref(
                          "users/${MainController.instance.user.uid}/requests");
                      DataSnapshot snapshot = await ref.get();
                      if (snapshot.exists) {
                        List<String> requests =
                            List.from((snapshot.value ?? []) as List);
                        requests.remove(uid);
                        await ref.set(
                            requests); // Remove the student ID from the requests list
                      }
                    },
                    child: const Text("Decline"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
