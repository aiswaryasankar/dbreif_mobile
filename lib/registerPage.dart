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
import 'package:flutter_application_1/loginPage.dart';
import 'package:flutter_application_1/verifyEmailPage.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
                key: formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 120),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 30),
                        child:
                            Image(image: AssetImage('assets/dbriefLogo.JPG')),
                      ),
                      Container(
                        width: 278,
                        margin: EdgeInsets.only(top: 30),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 239, 238, 238),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    hintText: 'Full Name',
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(68, 162, 159, 159)),
                                controller: fullNameController,
                                cursorColor: Colors.white,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      hintText: 'Email',
                                      filled: true,
                                      fillColor:
                                          Color.fromARGB(68, 162, 159, 159)),
                                  controller: emailController,
                                  cursorColor: Colors.white,
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (email) => email != null &&
                                          !EmailValidator.validate(email)
                                      ? 'Enter a valid email'
                                      : null),
                            ),
                            SizedBox(height: 20),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: 'Password',
                                  filled: true,
                                  fillColor: Color.fromARGB(68, 162, 159, 159),
                                ),
                                controller: passwordController,
                                textInputAction: TextInputAction.next,
                                obscureText: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    value != null && value.length < 8
                                        ? 'Enter minimum 8 characters'
                                        : null,
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    hintText: 'Confirm Password',
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(68, 162, 159, 159)),
                                controller: confirmPasswordController,
                                cursorColor: Colors.white,
                                textInputAction: TextInputAction.next,
                                validator: (value) =>
                                    value != passwordController.text
                                        ? 'Passwords do not match'
                                        : null,
                              ),
                            ),
                            SizedBox(height: 18),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: ButtonTheme(
                                minWidth: 270,
                                height: 50,
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size.fromHeight(50),
                                        primary: Colors.orange[700],
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    icon: Icon(Icons.arrow_forward, size: 32),
                                    label: Text(
                                      'Register',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    onPressed: () {
                                      signUp();
                                    }),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: ButtonTheme(
                                minWidth: 270,
                                height: 50,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      primary: Colors.orange,
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w900)),
                                  child: Text('Already have an account?'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const FourthPage(
                                                  title: 'Login Page',
                                                )));
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ]))),
      );
  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final user = FirebaseAuth.instance.currentUser!;
      postdata(fullNameController.text, user.uid);
      user.updateDisplayName(fullNameController.text);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => VerifyEmailPage()));
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
  }

  postdata(String fullName, String authID) async {
    String fullName = fullNameController.text;
    var names = fullName.split(' ');
    var lastName;
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
            "FirebaseAuthID": authID,
            "FirstName": firstName,
            "LastName": lastName,
            "Email": emailController.text
          }
        }));
    print(response.body);

    user["FirebaseAuthID"] = authID;
    user["FirstName"] = firstName;
    user["LastName"] = lastName;
    user["Email"] = emailController.text;
  }
}
