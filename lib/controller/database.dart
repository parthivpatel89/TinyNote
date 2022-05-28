import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// final CollectionReference _mainCollection = _firestore.collection('notes');
final CollectionReference _mainCollection =
    FirebaseFirestore.instance.collection('taskdetails');

class Database {
  static String? userUid;

  static Future<void> addItem(
      {required String task,
      required String description,
      required String dates,
      required String uid}) async {
    DocumentReference documentReferencer = _mainCollection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "TaskName": task,
      "Description": description,
      "Dates": dates,
      "UID": uid
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Task added to the database"))
        .catchError((e) => print(e));
  }

//Update record in firestore
  static Future<void> updateItem({
    required String task,
    required String description,
    required String dates,
    required String docId,
  }) async {
    DocumentReference documentReferencer = _mainCollection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "TaskName": task,
      "Description": description,
      "Dates": dates,
      // "UID": uid
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  ///get record from firestore
  static Stream<QuerySnapshot> readItems() {
    CollectionReference notesItemCollection = _mainCollection;

    return notesItemCollection.snapshots();
  }

  ///Delete Record from firestore
  static Future<void> deleteItem({
    required String docId,
  }) async {
    DocumentReference documentReferencer = _mainCollection.doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Task deleted from the database'))
        .catchError((e) => print(e));
  }
}
