import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Used to contain the action buttons for the alert dialogue.
class AlertDialogueAction {
  Widget child;
  void Function()? onPressed;

  AlertDialogueAction({required this.onPressed, required this.child});
}

/// Used to show an alert dialogue for both iOS and Android.
Future<T?> showAlertDialogue<T>(
    {required BuildContext context,
    Widget? title,
    Widget? content,
    List<AlertDialogueAction> actions = const <AlertDialogueAction>[]}) async {
  if (Platform.isIOS) {
    return await showCupertinoDialog<T>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: title,
        content: content,
        actions: [
          for (AlertDialogueAction action in actions)
            CupertinoButton(
              onPressed: action.onPressed,
              child: action.child,
            ),
        ],
      ),
    );
  } else {
    return await showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        title: title,
        content: content,
        actions: [
          for (AlertDialogueAction action in actions)
            TextButton(
              onPressed: action.onPressed,
              child: action.child,
            ),
        ],
      ),
    );
  }
}