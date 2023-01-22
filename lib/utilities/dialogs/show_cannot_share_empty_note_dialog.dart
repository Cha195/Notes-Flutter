import 'package:flutter/material.dart';
import 'package:test_app/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Error',
    content: 'Cannot Share Empty Note',
    optionsBuilder: () => {'OK': null},
  );
}
