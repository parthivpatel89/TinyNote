import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinynote/controller/authentication.dart';
import 'package:tinynote/controller/constants.dart';
import 'package:tinynote/screen/dashboard.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(constants.firebaseNavy),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });
                User? user =
                    await Authentication.signInWithGoogle(context: context);

                setState(() {
                  _isSigningIn = false;
                });

                if (user != null) {
                  await _users.add({
                    "uid": user.uid,
                    "name": user.displayName,
                    "email": user.email,
                    "photourl": user.photoURL
                  });

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => DashboardPage(
                        title: constants.appTitle,
                        user: user,
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Wrap(
                  children: <Widget>[
                    // const Image(
                    //   image: AssetImage("icons/notes.png"),
                    //   height: 20.0,
                    // ),

                    Container(
                        decoration: BoxDecoration(
                          color: constants.firebaseNavy,
                          // border: Border.all(color: Colors.white),
                          // borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(" Sign in with Google",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)))),
                  ],
                ),
              ),
            ),
    );
  }
}
