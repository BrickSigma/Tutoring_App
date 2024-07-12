import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tutoring_app/controllers/main_controller.dart';

/// Tasks controller for students.
class TasksController extends ChangeNotifier {
  final List<Map<String, dynamic>> tasks;

  TasksController(this.tasks) {
    FirebaseDatabase.instance
        .ref("users/${MainController.instance.user.uid}/todo")
        .onValue
        .listen(
      (event) {
        tasks.clear();
        SplayTreeMap<String, dynamic> data =
            SplayTreeMap.from((event.snapshot.value ?? {}) as Map);
        data.forEach((key, value) {
          tasks.add(Map<String, dynamic>.from(value as Map));
          notifyListeners();
        });
      },
    );
  }

  void addTask(String task) {
    if (task.isNotEmpty) {
      tasks.add({'task': task, 'completed': false});
    }
    saveTasks();
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    tasks[index]['completed'] = !tasks[index]['completed'];
    saveTasks();
    notifyListeners();
  }

  void saveTasks() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("users/${MainController.instance.user.uid}/todo");
    int i = 0;
    Map<String, dynamic> data = {};
    for (Map<String, dynamic> task in tasks) {
      data["task${i.toString().padLeft(4, "0")}"] = task;
      i++;
    }
    await ref.set(data);
  }
}
