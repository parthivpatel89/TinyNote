import 'package:flutter/material.dart';
import 'package:tinynote/controller/constants.dart';

import '../screen/addtask.dart';

class FAB extends StatelessWidget {
  final String uid;
  const FAB({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: constants.firebaseNavy,
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddTask(
                uid: uid, documentId: '', name: '', desc: '', dates: ''),
          )),
      child: const Icon(
        Icons.add_rounded,
        color: Colors.white,
      ),
    );
  }
}
