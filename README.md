# Tutoring App - OOP Project
This is a basic tutorin app made with Flutter and Dart.

## Objective
It is designed to make peer tutorin easier for people by allowing them to have all their students in one space and plan meetings and lessons on time.

## Flow
The app follows two paths:
- The first is for tutors,
- The second path is for students.

### Tutors
For tutors they have access to three different pages:
1. Students list - shows a list of students you tutor
2. Timetable page - shows a timetable of what day and time you meet a student in the week
3. Home page - shows the schedule for who you're tutoring on the current day

### Students
Students also have three different pages:
1. Todo list - a student can make a basic todo list here
2. Timetable - shows the student's schedule and when they are meeting their tutor
3. Home page - shows schedule and todo list for the current day

# Contributing
Some notes before working on the project:
- This project uses the MVC architecture, the project structure is as follows:
```
lib/
├─ controllers/
├─ models/
├─ views/
├─ main.dart
```
- The color scheme can be edited in the `/lib/views/utils/theme.dart` file.
- Storing data for now is done using shared preferences on the device, no cloud storage has been implemented yet.
- Data loading is handles in the `/lib/controllers/main_controller.dart` file.
- The main controller is a singleton class, all global variables like the timetable, todo list, students list, etc... are stored here and can be accessed from any where in the app.