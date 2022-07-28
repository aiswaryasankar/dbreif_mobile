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

import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/registerPage.dart';
import 'package:flutter_application_1/verifyEmailPage.dart';

class FourthPage extends StatelessWidget {
  const FourthPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) => Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Something went wrong!"));
            } else if (snapshot.hasData) {
              return VerifyEmailPage();
            } else {
              return AuthPage();
            }
          }));
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({
    Key? key,
  }) : super(key: key);
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final PasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    PasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 200),
                  Container(
                      margin: EdgeInsets.only(left: 40, right: 30),
                      child: Image(image: AssetImage('assets/dbriefLogo.JPG'))),
                  Container(
                    width: 278,
                    margin: EdgeInsets.only(top: 30),
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 239, 238, 238)),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                            controller: emailController,
                            cursorColor: Colors.white,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: "Email",
                                filled: true,
                                fillColor: Color.fromARGB(68, 162, 159, 159)),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                            controller: PasswordController,
                            cursorColor: Colors.white,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: "Password",
                                filled: true,
                                fillColor: Color.fromARGB(68, 162, 159, 159)),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: ButtonTheme(
                            minWidth: 270,
                            height: 50,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.orange[700],
                                  minimumSize: Size.fromHeight(50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              icon: Icon(Icons.lock_open, size: 32),
                              label: Text(
                                'Login',
                                style: TextStyle(fontSize: 18),
                              ),
                              onPressed: signIn,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: ButtonTheme(
                            minWidth: 270,
                            height: 50,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.orange[700],
                                  minimumSize: Size.fromHeight(50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              icon: Icon(Icons.lock_open, size: 32),
                              label: Text(
                                'Sign up',
                                style: TextStyle(fontSize: 18),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpWidget()));
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  )
                ])),
      );
  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: PasswordController.text.trim(),
      );
      final user = FirebaseAuth.instance.currentUser!;
      setData(user.email!, user.displayName!, user.photoURL!, user.uid);
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
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
