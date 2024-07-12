import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SearchResults extends StatefulWidget {
  const SearchResults(this.search, {super.key});

  final String search;

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  List<Widget> searchCards = [];

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
              searchCards.add(SearchCard(key, value["name"], subjects));
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
  const SearchCard(this.uid, this.name, this.subjects, {super.key});

  final String uid;
  final String name;
  final List<String> subjects;

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
