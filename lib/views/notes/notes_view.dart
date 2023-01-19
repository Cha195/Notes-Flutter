import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/constants/routes.dart';
import 'package:test_app/services/auth/auth_service.dart';
import 'package:test_app/services/crud/notes_service.dart';

import '../../enums/menu_action.dart';
import '../../utilities/show_logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        actions: [
          IconButton(
              onPressed: (() {
                Navigator.of(context).pushNamed('/$newNoteRoute');
              }),
              icon: const Icon(Icons.add)),
          PopupMenuButton(onSelected: ((value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/$baseRoute', (route) => false);
                } else {
                  return;
                }
                break;
            }
          }), itemBuilder: ((context) {
            return const [
              PopupMenuItem<MenuAction>(
                  value: MenuAction.logout, child: Text("Logout"))
            ];
          }))
        ],
      ),
      body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text("Waiting for notes");
                    default:
                      return const CircularProgressIndicator();
                  }
                }));
              default:
                return const CircularProgressIndicator();
            }
          })),
    );
  }
}
