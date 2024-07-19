import 'package:flutter/material.dart';
import 'package:tutoring_app/controllers/timetable_controller.dart';
import 'package:tutoring_app/views/tutor/timetable/timetable_input.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  Key key = UniqueKey();
  TimetableController controller = TimetableController();

  @override
  Widget build(BuildContext context) {
    Future<int> loadTimetable = Future.delayed(
      Duration.zero,
      () => controller.loadTimetableData(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (String day in [
              "Mon",
              "Tue",
              "Wed",
              "Thu",
              "Fri",
              "Sat",
              "Sun"
            ])
              Expanded(
                  child: Text(
                day,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              )),
          ],
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        key: key,
        future: loadTimetable,
        builder: (context, snapshot) {
          Widget child;

          if (snapshot.hasData) {
            child = Timetable(controller);
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
      floatingActionButton: IconButton(
        icon: const Icon(
          Icons.add,
          size: 23,
        ),
        onPressed: () => showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadiusDirectional.vertical(top: Radius.circular(20)),
          ),
          isScrollControlled: true,
          context: context,
          backgroundColor: Theme.of(context).colorScheme.surface,
          builder: (context) => TimetableInput(
            controller: controller,
          ),
        ),
      ),
    );
  }
}

class Timetable extends StatelessWidget {
  const Timetable(this.controller, {super.key});

  final TimetableController controller;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
