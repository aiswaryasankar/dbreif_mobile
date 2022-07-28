import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:email_validator/email_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_application_1/loginPage.dart';
import 'package:flutter_application_1/registerPage.dart';
import 'package:flutter_application_1/homePage.dart';
import 'package:flutter_application_1/main.dart';

class GoogleSignInApp extends StatefulWidget {
  const GoogleSignInApp({Key? key}) : super(key: key);

  @override
  State<GoogleSignInApp> createState() => _GoogleSignInAppState();
}

class _GoogleSignInAppState extends State<GoogleSignInApp> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  void initState() {
    _googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _googleSignIn.currentUser;
    final firebaseUser = FirebaseAuth.instance.currentUser;

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: Text('Google Sign In (Signed ' +
                    (user == null ? 'out' : 'in') +
                    ')')),
            body: Container(
              alignment: Alignment.center,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 135,
                        margin: EdgeInsets.only(bottom: 110),
                        child: Image.asset(
                          'assets/google.JPG',
                          scale: 1.5,
                        )),
                    Container(
                      width: 278,
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 239, 238, 238)),
                      child: Column(
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(130, 20),
                                  primary: Colors.green),
                              child: Text('Sign In'),
                              onPressed: user != null
                                  ? null
                                  : () async {
                                      await _googleSignIn.signIn();
                                      setState(() {});
                                    }),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(130, 20),
                                  primary: Colors.red),
                              child: Text('Sign Out'),
                              onPressed: user == null
                                  ? null
                                  : () async {
                                      await _googleSignIn.signOut();
                                      setState(() {});
                                    }),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(200, 20), primary: Colors.orange),
                        child: Text('Continue'),
                        onPressed: user == null
                            ? null
                            : () async {
                                setData(user.email, user.displayName!,
                                    user.photoUrl!, user.serverAuthCode!);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              }),
                  ]),
            )));
  }

  Future<void> setData(
      String email, String name, String photoUrl, String AuthCode) async {
    final SharedPreferences gPref = await SharedPreferences.getInstance();
    gPref.setString('email', email);
    gPref.setString('name', name);
    gPref.setString('photoUrl', photoUrl);
    gPref.setString('authCode', AuthCode);
  }
}
