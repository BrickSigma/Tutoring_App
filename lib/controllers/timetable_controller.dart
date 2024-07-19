import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tutoring_app/controllers/main_controller.dart';
import 'package:tutoring_app/models/tools.dart';

/// Used for the database initialization
final Map<String, String> nullTimeBlock = {
  "uid": "",
  "name": "",
  "start": "",
  "duration": ""
};

class TimetableController extends ChangeNotifier {
  List<List<Map<String, String>>> timetable = [];
  Map<String, String> students = {};

  Future<int> loadTimetableData() async {
    // Load the timetable for the user
    timetable.clear();
    students.clear();
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

    // Load the students of the tutor
    ref = FirebaseDatabase.instance
        .ref("users/${MainController.instance.user.uid}/students");
    snapshot = await ref.get();
    if (snapshot.exists) {
      List<String> studentIds = List.from((snapshot.value ?? []) as List);
      for (String id in studentIds) {
        ref = FirebaseDatabase.instance.ref("users/$id/name");
        snapshot = await ref.get();
        String name = snapshot.value.toString();
        students[id] = name;
      }
    }

    return 0;
  }

  /// Check if there is any free space for the time block requested.
  ///
  /// Return `true` if the block fits, and `false` if it doesn't.
  bool checkTimeBlock(int dayNo, Time start, Time duration) {
    int aMin = start.minutes;
    int aMax = start.add(duration).minutes;

    for (Map<String, String> t in timetable[dayNo]) {
      if (t["uid"]!.isEmpty) {
        continue;
      }
      int bMin = Time.parse(t["start"]!).minutes;
      int bMax = bMin + Time.parse(t["duration"]!).minutes;

      if (!((bMax <= aMin) || (bMin >= aMax))) {
        return false;
      }
    }

    return true;
  }

  void addTimeBlock(
      int dayNo, String uid, String name, Time start, Time duration) async {
    Map<String, String> timeBlock = {
      "uid": uid,
      "name": name,
      "start": start.toStringSeconds(),
      "duration": duration.toStringSeconds(),
    };

    timetable[dayNo].add(timeBlock);
    notifyListeners();

    DatabaseReference ref = FirebaseDatabase.instance
        .ref("users/${MainController.instance.user.uid}/timetable");
    await ref.set(timetable);

    // Add the timeblock for the student's timetable.
    Map<String, String> studentTimeBlock = {
      "uid": MainController.instance.user.uid!,
      "name": MainController.instance.user.name,
      "start": start.toStringSeconds(),
      "duration": duration.toStringSeconds(),
    };
    List<List<Map<String, String>>> studentTimetable = [];
    ref = FirebaseDatabase.instance.ref("users/$uid/timetable");
    DataSnapshot snapshot = await ref.get();
    if (snapshot.exists) {
      studentTimetable = (snapshot.value as List)
          .map(
            (e) => e = (e as List)
                .map(
                  (e) => e = Map<String, String>.from(e as Map),
                )
                .toList(),
          )
          .toList();
    }
    if (studentTimetable.isEmpty) {
      for (int i = 0; i < 7; i++) {
        studentTimetable.add([
          nullTimeBlock,
        ]);
      }
    }
    studentTimetable[dayNo].add(studentTimeBlock);
    await ref.set(studentTimetable);
  }

  void removeTimeBlock(
      int dayNo, String uid, String name, Time start, Time duration) async {
    Map<String, String> timeBlock = {
      "uid": uid,
      "name": name,
      "start": start.toStringSeconds(),
      "duration": duration.toStringSeconds(),
    };
    timetable[dayNo].removeWhere(
      (element) => (element["uid"] == timeBlock["uid"] &&
          element["start"] == timeBlock["start"] &&
          element["duration"] == timeBlock["duration"]),
    );
    notifyListeners();

    DatabaseReference ref = FirebaseDatabase.instance
        .ref("users/${MainController.instance.user.uid}/timetable");
    await ref.set(timetable);

    // Remove the timeblock from the student's timetable.
    Map<String, String> studentTimeBlock = {
      "uid": MainController.instance.user.uid!,
      "name": MainController.instance.user.name,
      "start": start.toStringSeconds(),
      "duration": duration.toStringSeconds(),
    };
    List<List<Map<String, String>>> studentTimetable = [];
    ref = FirebaseDatabase.instance.ref("users/$uid/timetable");
    DataSnapshot snapshot = await ref.get();
    if (snapshot.exists) {
      studentTimetable = (snapshot.value as List)
          .map(
            (e) => e = (e as List)
                .map(
                  (e) => e = Map<String, String>.from(e as Map),
                )
                .toList(),
          )
          .toList();
    }
    if (studentTimetable.isEmpty) {
      for (int i = 0; i < 7; i++) {
        studentTimetable.add([
          nullTimeBlock,
        ]);
      }
    }
    studentTimetable[dayNo].removeWhere(
      (element) => (element["uid"] == studentTimeBlock["uid"] &&
          element["start"] == studentTimeBlock["start"] &&
          element["duration"] == studentTimeBlock["duration"]),
    );
    await ref.set(studentTimetable);
  }
}
