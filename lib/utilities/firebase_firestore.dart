import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_todo_app/utilities/firebase_auth.dart';
import 'package:flutter_todo_app/utilities/todo_item.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

CollectionReference<ToDoItem> getEventRef(String currentUserUid) {
  return firestore
      .collection('TODO_DATA')
      .doc(currentUserUid)
      .collection("items")
      .withConverter(
        fromFirestore: (snapshot, _) => ToDoItem.fromJson(snapshot.data()!),
        toFirestore: (ToDoItem todoItem, _) => todoItem.toJson(),
      );
}

Future<void> addItem({
  required String title,
  required String information,
}) async {
  String currentUserUid = getLoggedInUserId();
  if (currentUserUid.isNotEmpty) {
    String ts = DateTime.now().millisecondsSinceEpoch.toString();

    final eventsRef = getEventRef(currentUserUid);

    await eventsRef.doc(ts).set(
          ToDoItem(
            id: ts,
            title: title,
            information: information,
          ),
        );
  }
}

Future<List<QueryDocumentSnapshot<ToDoItem>>?> getItems() async {
  String currentUserUid = getLoggedInUserId();
  if (currentUserUid.isNotEmpty) {
    final eventsRef = getEventRef(currentUserUid);

    return await eventsRef.get().then((snapshot) => snapshot.docs);
  }
  return null;
}
