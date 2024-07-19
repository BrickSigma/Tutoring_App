import 'package:flutter/material.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';
import 'package:tutoring_app/controllers/timetable_controller.dart';
import 'package:tutoring_app/models/tools.dart';
import 'package:tutoring_app/views/utils/widgets.dart';

class TimetableInput extends StatefulWidget {
  const TimetableInput({
    super.key,
    required this.controller,
    this.editing = false,
    this.timeBlock,
    this.timeBlockDayNo,
  });

  final bool editing;

  final Map<String, String>? timeBlock;
  final int? timeBlockDayNo;

  final TimetableController controller;

  @override
  State<TimetableInput> createState() => _TimetableInputState();
}

class _TimetableInputState extends State<TimetableInput> {
  String? day;
  String? name;
  Time start = Time(hour: 7, minute: 0);
  Time duration = Time(hour: 1, minute: 0);
  bool showStartTimeSpinner = false;
  bool showDurationTimeSpinner = false;
  DateTime time = DateTime.now();

  bool _isEditing() {
    return widget.editing &&
        widget.timeBlock != null &&
        widget.timeBlockDayNo != null;
  }

  @override
  void initState() {
    if (_isEditing()) {
      day = weekNamesShort[widget.timeBlockDayNo!];
      name = widget.timeBlock!["name"]!;
      start = Time.parse(widget.timeBlock!["start"]!);
      duration = Time.parse(widget.timeBlock!["duration"]!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Cancel button.
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              const Spacer(),
              Text("${_isEditing() ? "Edit" : "Add"} Student Meeting"),
              const Spacer(),
              TextButton(
                onPressed: (name != null && day != null)
                    ? () {
                        // Remove the old timeblock before editing it.
                        if (_isEditing()) {
                          widget.controller.timetable[widget.timeBlockDayNo!]
                              .removeWhere((element) =>
                                  (element["uid"] == widget.timeBlock!["uid"] &&
                                      element["start"] ==
                                          widget.timeBlock!["start"] &&
                                      element["duration"] ==
                                          widget.timeBlock!["duration"]));
                        }

                        int dayNo = weekNamesShort.indexOf(day!);

                        // Check if the time block will fit in the timetable and add it in.
                        if (widget.controller
                            .checkTimeBlock(dayNo, start, duration)) {
                          widget.controller.addTimeBlock(
                              dayNo,
                              widget.controller.students.keys.firstWhere(
                                (element) =>
                                    widget.controller.students[element] == name,
                              ),
                              name!,
                              start,
                              duration);
                          Navigator.pop(context);
                          return;
                        } else {
                          showAlertDialogue(
                            context: context,
                            title: const Text("Cannot add student!"),
                            content: const Text(
                                "A student is already in this period."),
                            actions: [
                              AlertDialogueAction(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Ok"))
                            ],
                          );
                        }
                      }
                    : null,
                child: Text(_isEditing() ? "Save" : "Add"),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    DropdownButton<String>(
                      style: TextStyle(
                          overflow: TextOverflow.fade,
                          color: Theme.of(context).colorScheme.primary),
                      value: name,
                      hint: const Text("Select a student"),
                      icon: const Icon(Icons.expand_more),
                      borderRadius: BorderRadius.circular(10),
                      items: [
                        for (String studentName
                            in widget.controller.students.values)
                          DropdownMenuItem<String>(
                            value: studentName,
                            child: SizedBox(
                              width: 164,
                              child: Text(
                                studentName,
                                softWrap: false,
                              ),
                            ),
                          ),
                      ],
                      onChanged: (value) => setState(() {
                        name = value;
                      }),
                    ),
                    const Spacer(),
                    DropdownButton<String>(
                      value: day,
                      hint: const Text("Day"),
                      icon: const Icon(Icons.expand_more),
                      borderRadius: BorderRadius.circular(10),
                      items: [
                        for (String s in weekNamesShort)
                          DropdownMenuItem<String>(
                            value: s,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(s),
                            ),
                          ),
                      ],
                      onChanged: (value) => setState(() {
                        day = value;
                      }),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 12,
                thickness: 2,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    const Text("Start: "),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          Theme.of(context).colorScheme.secondaryContainer,
                        ),
                      ),
                      onPressed: () => setState(() {
                        time = DateTime(2024, 1, 1, start.hour, start.minute);
                        showStartTimeSpinner = !showStartTimeSpinner;
                        showDurationTimeSpinner = false;
                      }),
                      child: Text(start.toString()),
                    ),
                    const Spacer(),
                    const Text("Duration: "),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          Theme.of(context).colorScheme.secondaryContainer,
                        ),
                      ),
                      onPressed: () => setState(() {
                        time = DateTime(
                            2024, 1, 1, duration.hour, duration.minute);
                        showDurationTimeSpinner = !showDurationTimeSpinner;
                        showStartTimeSpinner = false;
                      }),
                      child: Text(duration.toString()),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 12,
                thickness: 2,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              AnimatedSize(
                duration: const Duration(seconds: 1),
                child: showStartTimeSpinner || showDurationTimeSpinner
                    ? TimePickerSpinner(
                        key: Key(showStartTimeSpinner
                            ? "start spinner"
                            : "stop spinner"),
                        isForce2Digits: true,
                        minutesInterval: 5,
                        normalTextStyle: Theme.of(context).textTheme.bodyMedium,
                        highlightedTextStyle:
                            Theme.of(context).textTheme.bodyLarge,
                        time: time,
                        onTimeChange: (time) {
                          setState(() {
                            if (showStartTimeSpinner) {
                              start.hour = time.hour;
                              start.minute = time.minute;
                            } else {
                              duration.hour = time.hour;
                              duration.minute = time.minute;
                            }
                          });
                        },
                      )
                    : null,
              ),
              if (_isEditing() &&
                  (showStartTimeSpinner || showDurationTimeSpinner))
                Divider(
                  height: 12,
                  thickness: 2,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
              if (_isEditing())
                GestureDetector(
                  onTap: () {
                    widget.controller.removeTimeBlock(
                      widget.timeBlockDayNo!,
                      widget.timeBlock!["uid"]!,
                      widget.timeBlock!["name"]!,
                      Time.parse(widget.timeBlock!["start"]!),
                      Time.parse(widget.timeBlock!["duration"]!),
                    );
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "Delete Time Block",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}
