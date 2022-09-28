import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_todo_app/utilities/firebase_auth.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> addItem({
  required String title,
  required String information,
}) async {
  String currentUserUid = getLoggedInUserId();
  if (currentUserUid.isNotEmpty) {
    String ts = DateTime.now().millisecondsSinceEpoch.toString();

    await firestore
        .collection('TODO_DATA')
        .doc(currentUserUid)
        .collection("items")
        .doc(ts)
        .set({
      'id': ts,
      'title': title,
      'information': information,
    });
  }
}
