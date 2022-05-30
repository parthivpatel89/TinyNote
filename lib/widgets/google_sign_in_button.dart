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
                backgroundColor: MaterialStateProperty.all(constants.white),
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
                  QuerySnapshot rsult = await FirebaseFirestore.instance
                      .collection("users")
                      .where("email", isEqualTo: user.email)
                      .get();
                  print(rsult);
                  final List<DocumentSnapshot> docs = rsult.docs;
                  print(docs);
                  if (docs.length == 0) {
                    await _users.add({
                      "uid": user.uid,
                      "name": user.displayName,
                      "email": user.email,
                      "photourl": user.photoURL
                    });
                  } else {}

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
                  children: const <Widget>[
                    Image(
                      image: AssetImage("assets/icons/google_logo.png"),
                      height: 35.0,
                    ),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(" Sign in with Google",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ))),
                  ],
                ),
              ),
            ),
    );
  }
}
