import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class TodoRepository {
  // Create a CollectionReference called todos that references the firestore collection
  CollectionReference todos = FirebaseFirestore.instance.collection('todos');

  Stream<QuerySnapshot> collectionStream =
      FirebaseFirestore.instance.collection('todos').snapshots();

  Future<void> addTodo(String todoName, BuildContext context) async {
    //-getting an unique document ID
    String docid = todos.doc().id;

    // Call the todos's CollectionReference to add a new todo
    try {
      return todos.doc(docid).set({
        'id': docid,
        'todoName': todoName,
        'completedStatus': false
      }).then((value) => AnimatedSnackBar.material(
            'Todo Added',
            type: AnimatedSnackBarType.success,
          ).show(context));
    } catch (e) {
      Logger().e(e);
    }
  }

  //delete todo. If todo deleted it shows an warning snackbar
  Future<void> deleteTodo(String id, BuildContext context) {
    try {
      return todos.doc(id).delete().then((value) => AnimatedSnackBar.material(
            'Todo Deleted',
            type: AnimatedSnackBarType.warning,
          ).show(context));
    } catch (e) {
      Logger().e(e);
      throw Exception(e);
    }
  }

  //update completedStatus to true. If todo completed it shows an success snackbar
  Future<void> completeTodo(String id, BuildContext context) {
    try {
      return todos.doc(id.toString()).update({'completedStatus': true}).then(
          (value) => AnimatedSnackBar.material(
                'Todo Completed',
                type: AnimatedSnackBarType.success,
              ).show(context));
    } catch (e) {
      Logger().e(e);
      throw Exception(e);
    }
  }

  //update todo completedStatus to false. If todo completed it shows an info snackbar
  Future<void> inCompletedTodo(String id, BuildContext context) {
    try {
      return todos.doc(id.toString()).update({'completedStatus': false}).then(
          (value) => AnimatedSnackBar.material(
                'Todo not Completed',
                type: AnimatedSnackBarType.info,
              ).show(context));
    } catch (e) {
      Logger().e(e);
      throw Exception(e);
    }
  }
}
