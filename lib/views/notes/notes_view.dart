import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/constants/routes.dart';
import 'package:test_app/services/auth/auth_service.dart';
import 'package:test_app/services/cloud/cloud_note.dart';
import 'package:test_app/services/cloud/firebase_cloud_storage.dart';
import 'package:test_app/views/notes/notes_list_view.dart';

import '../../enums/menu_action.dart';
import '../../utilities/dialogs/show_logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        actions: [
          IconButton(
              onPressed: (() {
                Navigator.of(context).pushNamed('/$createOrUpdateNoteRoute');
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
      body: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                    notes: allNotes,
                    onDeleteNote: ((note) async {
                      await _notesService.deleteNote(
                          documentId: note.documentId);
                    }),
                    onTapNote: (CloudNote note) async {
                      Navigator.of(context).pushNamed(
                        '/$createOrUpdateNoteRoute',
                        arguments: note,
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          })),
    );
  }
}
