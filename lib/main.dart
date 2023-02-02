import 'package:flutter/material.dart';
import 'package:test_app/constants/routes.dart';
import 'package:test_app/views/notes/create_update_note_view.dart';
import 'package:test_app/views/notes/notes_view.dart';

import 'package:test_app/views/login_view.dart';
import 'package:test_app/views/register_view.dart';
import 'package:test_app/views/verify_email_view.dart';

import 'package:test_app/services/auth/auth_service.dart';

import 'constants/navigator_key.dart';

Map<String, WidgetBuilder> routes = {
  "/$loginRoute": (context) => const LoginView(),
  "/$registerRoute": (context) => const RegisterView(),
  "/$notesRoute": (context) => const NotesView(),
  "/$createOrUpdateNoteRoute": (context) => const CreateUpdateNoteView(),
  "/$baseRoute": (context) => const HomePage(),
};

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'PP',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: routes,
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
