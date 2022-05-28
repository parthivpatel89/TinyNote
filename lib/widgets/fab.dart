import 'package:flutter/material.dart';

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
      backgroundColor: Colors.redAccent,
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddTask(
                uid: uid, documentId: '', name: '', desc: '', dates: ''),
          )),
      child: const Icon(
        Icons.edit,
        color: Colors.white,
      ),
    );
  }
}
