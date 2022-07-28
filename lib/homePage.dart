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
import 'package:flutter_application_1/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? gEmail;
  String? gName;
  String? gPhoto;
  String? gAuthCode;

  @override
  void initState() {
    super.initState();
    getData();
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in Success'),
      ),
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Signed in as',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Container(
              child: gEmail == null ? Text('No Data') : Text(gEmail!),
            ),
            SizedBox(height: 20),
            Container(
              child: gName == null ? Text('No Data') : Text(gName!),
            ),
            SizedBox(height: 20),
            Container(
              child: gPhoto == null ? Text('No Data') : Image.network(gPhoto!),
            ),
            SizedBox(height: 20),
            Container(
              child: gAuthCode == null ? Text('No Data') : Text(gAuthCode!),
            ),
            SizedBox(height: 15),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(130, 20), primary: Colors.red),
                child: Text('Sign Out'),
                onPressed: () async {
                  await _googleSignIn.signOut();
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FirstPage(
                                title: 'FirstPage',
                              )));
                  setState(() {});
                }),
          ],
        ),
      ),
    );
  }

  void getData() async {
    final SharedPreferences gPref = await SharedPreferences.getInstance();
    gEmail = gPref.getString('email');
    gName = gPref.getString('name');
    gPhoto = gPref.getString('photoUrl');
    gAuthCode = gPref.getString('authCode');

    setState(() {});
  }
}
