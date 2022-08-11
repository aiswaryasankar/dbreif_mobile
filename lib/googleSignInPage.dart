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
    GoogleSignInAccount? guser = _googleSignIn.currentUser;
    final firebaseUser = FirebaseAuth.instance.currentUser;

    return MaterialApp(
        home: Scaffold(
            body: Container(
      alignment: Alignment.center,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 135,
                //margin: EdgeInsets.only(bottom: 110),
                child: Image.asset(
                  'assets/google.JPG',
                  scale: 1.5,
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height / 8,
            ),
            Container(
              width: 278,
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 239, 238, 238)),
              child: Column(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(130, 20), primary: Colors.green),
                      child: Text('Sign In'),
                      onPressed: guser != null
                          ? null
                          : () async {
                              final googleUser = await _googleSignIn.signIn();

                              final GoogleSignInAuthentication googleAuth =
                                  await googleUser!.authentication;

                              final credential = GoogleAuthProvider.credential(
                                  accessToken: googleAuth.accessToken,
                                  idToken: googleAuth.idToken);

                              await FirebaseAuth.instance
                                  .signInWithCredential(credential);
                              print(1);

                              testFunction(googleUser.displayName!,
                                  googleUser.serverAuthCode!, googleUser.email);

                              print(2);

                              // getUser(
                              //     googleUser.displayName!,
                              //     googleUser.serverAuthCode!,
                              //     googleUser.email);

                              setState(() {});
                            }),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(130, 20), primary: Colors.blue),
                      child: Text('Register'),
                      onPressed: guser == null
                          ? () async {
                              final googleUser = await _googleSignIn.signIn();

                              final GoogleSignInAuthentication googleAuth =
                                  await googleUser!.authentication;

                              final credential = GoogleAuthProvider.credential(
                                  accessToken: googleAuth.accessToken,
                                  idToken: googleAuth.idToken);

                              await FirebaseAuth.instance
                                  .signInWithCredential(credential);

                              CreateUser(
                                  googleUser.displayName!, googleUser.email);

                              setState(() {});
                            }
                          : null),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(130, 20), primary: Colors.red),
                      child: Text('Sign Out'),
                      onPressed: guser == null
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
                onPressed: guser == null
                    ? null
                    : () async {
                        print(guser);
                        getUser(guser.displayName!, guser.serverAuthCode!,
                            guser.email);

                        //setData(guser.email, guser.displayName!,
                        //guser.serverAuthCode!);
                      }),
          ]),
    )));
  }

  getUser(String fullName, String authID, String email) async {
    var names = fullName.split(' ');
    var lastName;
    final testUser = FirebaseAuth.instance.currentUser!;
    String firstName = names[0];
    if (firstName == fullName) {
      lastName = "";
    } else {
      lastName = names[1];
    }

    var response = await http.post(
        Uri.parse(
            "https://ddbrief.com/getUser/?Content-Type=application/json&Accept=application/json,text/plain,/"),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode({
          "firebaseAuthId": testUser.uid,
        }));
    print(response.body);

    var resultingString =
        response.body.substring(11, response.body.length - 19);

    String resulting = resultingString.replaceAll(r'\"', '"');
    user = jsonDecode(resulting);

    final SharedPreferences gPref = await SharedPreferences.getInstance();
    gPref.setString('authCode', testUser.uid);

    print(100);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  CreateUser(String fullName, String Email) async {
    var names = fullName.split(' ');
    var lastName;
    final testUser = FirebaseAuth.instance.currentUser!;
    String firstName = names[0];
    if (firstName == fullName) {
      lastName = "";
    } else {
      lastName = names[1];
    }

    var response = await http.post(
        Uri.parse(
            "https://ddbrief.com/createUser/?Content-Type=application/json&Accept=application/json,text/plain,/"),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode({
          "user": {
            "FirebaseAuthID": testUser.uid,
            "FirstName": firstName,
            "LastName": lastName,
            "Email": Email
          }
        }));
    print(response.body);

    user["FirebaseAuthID"] = testUser.uid;
    user["FirstName"] = firstName;
    user["LastName"] = lastName;
    user["Email"] = Email;
  }

  testFunction(String fullName, String AuthId, String email) async {
    print(7);
    var names = fullName.split(' ');
    var lastName;
    final testUser = FirebaseAuth.instance.currentUser!;
    String firstName = names[0];
    if (firstName == fullName) {
      lastName = "";
    } else {
      lastName = names[1];
    }

    try {
      var response = await http.post(
          Uri.parse(
              "https://ddbrief.com/getUser/?Content-Type=application/json&Accept=application/json,text/plain,/"),
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json"
          },
          body: jsonEncode({
            "firebaseAuthId": testUser.uid,
          }));
      print(6);
      print(testUser.uid);
      var resultingString =
          response.body.substring(11, response.body.length - 19);

      String resulting = resultingString.replaceAll(r'\"', '"');
      user = jsonDecode(resulting);

      final SharedPreferences gPref = await SharedPreferences.getInstance();
      gPref.setString('authCode', testUser.uid);

      return true;
    } on Exception catch (e) {
      print("ga bisa");

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Sign In Denied"),
                content: Text("Please Register your account before Signing In"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Ok"))
                ],
              ));

      await _googleSignIn.signOut();
      FirebaseAuth.instance.signOut();
      setState(() {});
      print("snackbar ke print?");
      return false;
    }

    print(100);
  }
}
