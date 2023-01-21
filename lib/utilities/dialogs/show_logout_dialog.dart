import 'package:flutter/material.dart';
import 'package:test_app/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Logout",
    content: "Are you sure?",
    optionsBuilder: () => {"Confirm": true, "Cancel": false},
  ).then((value) => value ?? false);
}
