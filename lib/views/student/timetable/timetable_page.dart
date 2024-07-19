import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tutoring_app/controllers/main_controller.dart';
import 'package:tutoring_app/controllers/timetable_controller.dart';
import 'package:tutoring_app/models/tools.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  Key key = UniqueKey();
  TimetableController controller = TimetableController();

  Future<int> _loadTimetable() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("users/${MainController.instance.user.uid}/timetable");
    DataSnapshot snapshot = await ref.get();
    if (snapshot.exists) {
      controller.timetable = (snapshot.value as List)
          .map(
            (e) => e = (e as List)
                .map(
                  (e) => e = Map<String, String>.from(e as Map),
                )
                .toList(),
          )
          .toList();
    }
    if (controller.timetable.isEmpty) {
      for (int i = 0; i < 7; i++) {
        controller.timetable.add([
          nullTimeBlock,
        ]);
      }
    }
    await ref.set(controller.timetable);

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
        titleSpacing: 0,
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
            child = SingleChildScrollView(
              child: ListenableBuilder(
                  listenable: controller,
                  builder: (context, child) {
                    return Timetable(controller);
                  }),
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

class Timetable extends StatelessWidget {
  const Timetable(this.controller, {super.key});

  final TimetableController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < 7; i++) DayColumn(controller, i),
      ],
    );
  }
}

/// Column for each day to hold TimeBlockContainers.
class DayColumn extends StatelessWidget {
  /// Height of a timeblock.
  ///
  /// Set to pixels per minute (eg 3 is is pixels per minute in the time block).
  static const double timeBlockHeight = 3;

  final TimetableController controller;
  final int dayNo;

  const DayColumn(this.controller, this.dayNo, {super.key});

  @override
  Widget build(BuildContext context) {
    // List of time blocks and spacers for day column.
    List<Widget> blocks = [];

    for (Map<String, String> t in controller.timetable[dayNo]) {
      if (t["uid"]!.isEmpty) {
        continue;
      }
      int diff = Time.parse(t["start"]!).minutes - Time(hour: 5).minutes;
      blocks.add(
        Positioned(
          left: 0,
          right: 0,
          top: diff.toDouble(),
          child: TimeBlockContainer(
            controller: controller,
            dayNo: dayNo,
            timeblock: t,
          ),
        ),
      );
    }
    blocks.add(Container(height: 96));

    return SizedBox(
      height: 2000,
      width: MediaQuery.sizeOf(context).width / 7,
      child: Stack(
        children: blocks,
      ),
    );
  }
}

/// Display TimeBlock details.
class TimeBlockContainer extends StatelessWidget {
  const TimeBlockContainer({
    super.key,
    required this.controller,
    required this.timeblock,
    required this.dayNo,
  });

  final Map<String, String> timeblock;
  final TimetableController controller;
  final int dayNo;

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(fontSize: 12);

    return Padding(
      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        height: Time.parse(timeblock["duration"]!).minutes *
            DayColumn.timeBlockHeight,
        child: (Time.parse(timeblock["duration"]!).minutes >= 30)
            ? ConstrainedBox(
                constraints:
                    const BoxConstraints.expand(width: double.infinity),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                      child: Text(
                        Time.parse(timeblock["start"]!).toString(),
                        style: style,
                      ),
                    ),
                    Expanded(
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: Text(
                          timeblock["name"]!,
                          textAlign: TextAlign.center,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                      child: Text(
                        Time.parse(timeblock["start"]!)
                            .add(Time.parse(timeblock["duration"]!))
                            .toString(),
                        style: style,
                      ),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
