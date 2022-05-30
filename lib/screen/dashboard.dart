import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinynote/controller/constants.dart';
import 'package:tinynote/screen/addtask.dart';
import 'package:tinynote/screen/login.dart';
import 'package:tinynote/widgets/fab.dart';
import 'package:tinynote/widgets/logoutbar.dart';
import '../controller/authentication.dart';
import '../controller/database.dart';
import '../controller/exitpopup.dart';
import '../widgets/customappbar.dart';

class DashboardPage extends StatefulWidget {
  final String title = "";

  const DashboardPage({Key? key, String? title, required User user})
      : _user = user,
        super(key: key);

  final User _user;
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late User _user;
  bool _isSigningOut = false;

  final CollectionReference _tasks =
      FirebaseFirestore.instance.collection('taskdetails');

  showAlertDialog(BuildContext context, String taskId) {
    Widget yesButton = ElevatedButton(
      child: Text("Yes"),
      onPressed: () async {
        // _deleteTask(taskId);

        await Database.deleteItem(docId: taskId);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('You have successfully deleted a task')));
        Navigator.of(context).pop();
      },
    );
    Widget noButton = ElevatedButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Task"),
      content: Text("Are you sure to delete this task ?"),
      actions: [yesButton, noButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // // Deleteing a task by id
  // Future<void> _deleteTask(String taskId) async {

  // }

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(

        ///handle back button
        onWillPop: () => showExitPopup(context),
        child: Scaffold(
            appBar: CustomAppBar(),
            drawer: Drawer(
                child: ListView() // Populate the Drawer in the next step.
                ),
            // Using StreamBuilder to display all Tasks from Firestore in real-time
            body: Column(
              children: <Widget>[
                // Container(
                //   padding: EdgeInsets.all(10),
                //   child: Text(
                //     'Welcome ${_user.displayName}',
                //     style: TextStyle(
                //       color: constants.hint,
                //       fontSize: 22.0,
                //       letterSpacing: 1,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                Expanded(
                  child: StreamBuilder(
                    stream: _tasks.snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];
                            String docID = streamSnapshot.data!.docs[index].id;
                            if (documentSnapshot['UID'] == _user.uid) {
                              return Wrap(
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(10),
                                      margin: const EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      //color: Colors.orange,
                                      child: Text(
                                        documentSnapshot['Dates'],
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.black54),

                                        // ],
                                      )),
                                  Card(
                                    margin: const EdgeInsets.all(10),
                                    child: ListTile(
                                      leading: Container(
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            border: Border.all(
                                                width: 2, color: Colors.grey)),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.lightBlue,
                                        ),
                                      ),
                                      title: Text(
                                        documentSnapshot['TaskName'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                          documentSnapshot['Description']
                                              .toString()),
                                      trailing: SizedBox(
                                        width: 100,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            // Press this button to edit a single Task
                                            IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.blue,
                                                ),
                                                onPressed: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddTask(
                                                        uid: _user.uid,
                                                        documentId: docID,
                                                        name: documentSnapshot[
                                                            'TaskName'],
                                                        desc: documentSnapshot[
                                                            'Description'],
                                                        dates: documentSnapshot[
                                                                'Dates']
                                                            .toString(),
                                                      ),
                                                    ))),
                                            // This icon button is used to delete a single Task
                                            IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () =>
                                                    showAlertDialog(context,
                                                        documentSnapshot.id)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            } else
                              return SizedBox();
                          },
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ],
            ),
            // Add new Task
            floatingActionButton: FAB(
              uid: _user.uid,
            )));
  }
}
