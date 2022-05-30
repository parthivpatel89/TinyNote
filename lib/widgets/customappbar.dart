import 'package:flutter/material.dart';
import 'package:tinynote/controller/constants.dart';

import 'logoutbar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 150,
      flexibleSpace: const Image(
        image: AssetImage('assets/icons/nature.jpg'),
        fit: BoxFit.cover,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white, //change your color here
      ),
      centerTitle: true,
      title: Text(
        "Your Things", //constants.appTitle,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: constants.firebaseNavy,
      actions: <Widget>[Logout()],
    );
  }
}
