import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tutoring_app/controllers/main_controller.dart';

class SearchResults extends StatefulWidget {
  const SearchResults(this.search, {super.key});

  final String search;

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  List<Widget> searchCards = [];
  Key key = UniqueKey();

  void update() => setState(() => key = UniqueKey());

  /// Used to search for tutors using the subject they teach.
  Future<int> searchTutors() async {
    final snapshot = await FirebaseDatabase.instance.ref("users").get();
    searchCards.clear();
    if (snapshot.exists) {
      Map<String, dynamic> users = Map.from(snapshot.value as Map);
      users.forEach(
        (key, value) {
          List<String> subjects = List.from((value["subjects"] ?? []) as List);
          for (String subject in subjects) {
            if (subject.toLowerCase().contains(widget.search.toLowerCase())) {
              List<String> tutorRequests =
                  List.from((value["requests"] ?? []) as List);
              int connectionType = 0;

              // Check if the user has already sent a request to the tutor before
              if (tutorRequests.contains(MainController.instance.user.uid)) {
                connectionType = 1;
              } else if (MainController.instance.user.tutors.contains(key)) {
                // Check if the tutor is already connected with the student.
                connectionType = 2;
              }
              searchCards.add(SearchCard(
                  key, value["name"], subjects, connectionType, update));
              break;
            }
          }
        },
      );
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    Future<int> search = Future<int>.delayed(
      Duration.zero,
      () => searchTutors(),
    );

    return FutureBuilder(
      key: key,
      future: search,
      builder: (context, snapshot) {
        Widget child;

        if (snapshot.hasData) {
          child = ListView(
            children: searchCards,
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
    );
  }
}

class SearchCard extends StatelessWidget {
  const SearchCard(
      this.uid, this.name, this.subjects, this.connectionType, this.update,
      {super.key});

  final String uid;
  final String name;
  final List<String> subjects;
  final Function() update;

  /// `0`: the student has never sent a request to the tutor
  ///
  /// `1`: the student has sent a pending request to the tutor
  ///
  /// `2`: the tutor is already connected with the student
  final int connectionType;

  @override
  Widget build(BuildContext context) {
    late Widget requestButton;

    if (connectionType == 0) {
      requestButton = TextButton(
        onPressed: () async {
          DatabaseReference ref =
              FirebaseDatabase.instance.ref("users/$uid/requests");
          final snapshot = await ref.get();
          List<String> requests = [];
          if (snapshot.exists) {
            requests = List.from((snapshot.value ?? []) as List);
          }
          requests.add(MainController.instance.user.uid!);
          await ref.set(requests);
          update();
        },
        child: const Text("Send request"),
      );
    } else if (connectionType == 1) {
      requestButton = const Text(
        "Request Pending",
        style: TextStyle(color: Colors.orange),
      );
    } else {
      requestButton = const Text(
        "Accepted",
        style: TextStyle(color: Colors.green),
      );
    }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name),
                  requestButton,
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (String subject in subjects) SubjectBox(subject),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SubjectBox extends StatelessWidget {
  const SubjectBox(this.subject, {super.key});

  final String subject;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.surface),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Center(
            child: Text(
              subject,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ),
    );
  }
}
