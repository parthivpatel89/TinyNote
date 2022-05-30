import 'package:flutter/material.dart';

import '../controller/authentication.dart';
import '../screen/login.dart';

class Logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.person_off,
        color: Colors.white,
      ),
      onPressed: () async {
        // setState(() {
        //   _isSigningOut = true;
        // });
        await Authentication.signOut(context: context);
        // setState(() {
        //   _isSigningOut = false;
        // });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      },
    );
  }
}
