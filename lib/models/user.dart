import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

/// Used to store generic user information.
///
/// Extended by the `Student` and `Tutor` models.
class UserModel {
  String name = "";
  String? uid;
  bool tutor = false;
  DatabaseReference? _userData;

  /// STUDENT RELATED DATA
  /// ======================================

  /// List of tasks for student's todo list.
  final List<Map<String, dynamic>> tasks = [];

  // List of tutors assigned to student.
  List<String> tutors = [];

  /// TUTOR RELATED DATA
  /// ======================================

  /// List of student requests
  List<String> requests = [];

  /// List of students accepted by tutor
  List<String> students = [];

  UserModel({required this.uid}) {
    _userData = FirebaseDatabase.instance.ref("users/$uid");
  }

  bool isTutor() => tutor;

  /// Used to login a new user.
  static Future<void> loginUser(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> createUser(
      String email, String password, String name, bool isTutor) async {
    UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await FirebaseDatabase.instance.ref().update({
      "users/${credential.user!.uid}": {"name": name, "tutor": isTutor}
    });
  }

  /// Initialize the user data.
  ///
  /// If the uid is set to `null`, then the user is considered logged out
  /// and no data will be loaded.
  Future<void> initialize() async {
    if (_userData == null || uid == null) {
      name = "";
      tutor = false;
      return;
    }
    final snapshot = await _userData!.get();
    if (snapshot.exists) {
      Map<String, dynamic> data = Map.from(snapshot.value as Map);
      name = data["name"];
      tutor = data["tutor"] as bool;
      if (!tutor) {
        // Load the data if the user is a student.
        await _loadTasks();
        // Load the tutors list
        await _loadTutors();
      } else {
        await _loadTutorData();
      }
    } else {
      throw Exception("No data found for user!");
    }
  }

  /// Load the tasks for the student.
  Future<void> _loadTasks() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid/todo");
    final snapshot = await ref.get();
    if (snapshot.exists) {
      SplayTreeMap<String, dynamic> data =
          SplayTreeMap.from(snapshot.value as Map);
      data.forEach((key, value) {
        tasks.add(Map<String, dynamic>.from(value as Map));
      });
    }
  }

  Future<void> _loadTutors() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid/tutors");
    final snapshot = await ref.get();
    if (snapshot.exists) {
      tutors = List.from((snapshot.value ?? []) as List);
    }
  }

  Future<void> _loadTutorData() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("users/$uid/requests");
    DataSnapshot snapshot = await ref.get();
    if (snapshot.exists) {
      requests = List.from((snapshot.value ?? []) as List);
    }
    ref = FirebaseDatabase.instance.ref("users/$uid/students");
    snapshot = await ref.get();
    if (snapshot.exists) {
      students = List.from((snapshot.value ?? []) as List);
    }
  }
}
