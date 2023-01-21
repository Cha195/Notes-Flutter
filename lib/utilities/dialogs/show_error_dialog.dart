import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String errorMessage) {
  return showGenericDialog<void>(
    context: context,
    title: "Error",
    content: errorMessage,
    optionsBuilder: () => {'OK': null},
  );
}
