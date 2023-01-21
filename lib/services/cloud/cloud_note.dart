import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudNote {
  final String text;
  final String ownerUserId;
  final String documentId;

  const CloudNote({
    required this.text,
    required this.ownerUserId,
    required this.documentId,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String;
}
