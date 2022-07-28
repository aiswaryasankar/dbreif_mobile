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
import 'package:flutter_application_1/googleSignInPage.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Reset Password'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Receive an email to\nreset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(labelText: 'Email'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Enter a valid email'
                          : null,
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  icon: Icon(Icons.email_outlined),
                  label: Text(
                    "Reset Password",
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: resetPassword,
                ),
              ],
            ),
          ),
        ),
      );
  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      Utils.showSnackBar('Password Reset Email Sent');
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
  }
}

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        title: 'Naviation Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const FirstPage(title: 'Home'),
      );
}

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key, required this.title}) : super(key: key);
  final String title;
  final bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 60),
            Container(
                width: 250,
                margin: EdgeInsets.only(left: 40, right: 40),
                child: Image(image: AssetImage('assets/dbriefLogo.JPG'))),
            SizedBox(height: 22),
            Container(
                margin: EdgeInsets.only(left: 40, right: 40),
                child: Image(image: AssetImage('assets/dbriefLaptop.jpg'))),
            SizedBox(height: 15),
            Container(
              child: Text(
                "Get the entire news",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            Container(
              child: Text(
                "story in seconds",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              child: Text(
                "Don't blindly believe the first tweet,",
              ),
            ),
            Container(
              child: Text(
                "post, or article you read about a",
              ),
            ),
            Container(
              child: Text(
                "story again.",
              ),
            ),
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: ButtonTheme(
                minWidth: 270,
                height: 47.0,
                child: RaisedButton(
                  color: Colors.orange[700],
                  //disabledColor: Colors.orange[700],
                  textColor: Colors.white,
                  //disabledTextColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 16.0, // insert your font size here
                        fontWeight: FontWeight.bold),
                  ),

                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FourthPage(
                                  title: "Login Page",
                                )));
                  },
                ),
              ),
            ),
            SizedBox(height: 4),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: ButtonTheme(
                minWidth: 270,
                height: 35.0,
                child: RaisedButton(
                  textColor: Colors.grey[700],
                  color: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    'Register',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    var user = FirebaseAuth.instance.currentUser?.emailVerified;
                    user != null
                        ? Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HomePage()))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpWidget()));
                  },
                ),
              ),
            ),
            SizedBox(height: 4),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              width: 270,
              child: ButtonTheme(
                height: 35.0,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 161, 206, 163),
                    onPrimary: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.black,
                  ),
                  label: Text('Sign in With Google'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GoogleSignInApp()));
                  },
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              child: Text(
                "Debrief.AI is a news search engine based on state of",
              ),
            ),
            Container(
              child: Text(
                "the art research to search, summarie, and organize",
              ),
            ),
            Container(
              child: Text(
                "news contect across all platforms",
              ),
            ),
            SizedBox(
              height: 110,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: ButtonTheme(
                minWidth: 70.0,
                height: 55.0,
                child: RaisedButton(
                  color: Colors.orange[700],
                  //disabledColor: Colors.orange[700],
                  textColor: Colors.white,
                  //disabledTextColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    '1',
                    style: TextStyle(
                        fontSize: 40.0, // insert your font size here
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SecondPage(title: 'Sign Up Page')));
                  },
                ),
              ),
            ),
            SizedBox(height: 28),
            Container(
              child: Text(
                "Let our AI powered",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            Container(
              child: Text(
                "news engine digest",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            Container(
              child: Text(
                "the news for you",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            SizedBox(height: 15),
            Container(
                width: 700.0,
                child: Center(
                    child: Text(
                  'Save yourself hours parsing through all the',
                  style: TextStyle(fontSize: 17),
                ))),
            Container(
                width: 700.0,
                child: Center(
                    child: Text(
                  'articles, shows and content yourself',
                  style: TextStyle(fontSize: 17),
                ))),
            SizedBox(height: 25),
            Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                child: Image(image: AssetImage('assets/dbriefOne.JPG'))),
            SizedBox(height: 120),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: ButtonTheme(
                minWidth: 70.0,
                height: 55.0,
                child: RaisedButton(
                  color: Colors.orange[700],
                  //disabledColor: Colors.orange[700],
                  textColor: Colors.white,
                  //disabledTextColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    '2',
                    style: TextStyle(
                        fontSize: 40.0, // insert your font size here
                        fontWeight: FontWeight.bold),
                  ),

                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SecondPage(title: 'Sign Up Page')));
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 700.0,
                    child: Center(
                        child: Text(
                      'Cross check any tweet, article,',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                    ))),
                Container(
                    width: 700.0,
                    child: Center(
                        child: Text(
                      'or comments against all',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                    ))),
                Container(
                    width: 700.0,
                    child: Center(
                        child: Text(
                      'content on the web',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                    ))),
                SizedBox(height: 20.0),
                Container(
                    width: 700.0,
                    child: Center(
                        child: Text(
                      'Access additional relevant information from a',
                      style: TextStyle(fontSize: 17),
                    ))),
                Container(
                    width: 700.0,
                    child: Center(
                        child: Text(
                      'holistic vantage point wherever you are',
                      style: TextStyle(fontSize: 17),
                    ))),
                SizedBox(height: 20.0),
                Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: Image(image: AssetImage('assets/dbriefChat.JPG'))),
                SizedBox(height: 100),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: ButtonTheme(
                    minWidth: 70.0,
                    height: 55.0,
                    child: RaisedButton(
                      color: Colors.orange[700],
                      //disabledColor: Colors.orange[700],
                      textColor: Colors.white,
                      //disabledTextColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        '3',
                        style: TextStyle(
                            fontSize: 40.0, // insert your font size here
                            fontWeight: FontWeight.bold),
                      ),

                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SecondPage(title: 'Sign Up Page')));
                      },
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  child: Text(
                    "Tailor your newsletter.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                Container(
                  child: Text(
                    "Cull your input.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                    width: 700.0,
                    child: Center(
                        child: Text(
                      'Curate your daily news digest to your interests.',
                      style: TextStyle(fontSize: 17),
                    ))),
                Container(
                    width: 700.0,
                    child: Center(
                        child: Text(
                      'Choose your preferred sources.',
                      style: TextStyle(fontSize: 17),
                    ))),
                SizedBox(height: 20),
                Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: Image(image: AssetImage('assets/dbriefThree.JPG'))),
                SizedBox(height: 100),
                Container(
                  child: Text(
                    "Don't let us",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                Container(
                  child: Text(
                    "Convince you.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: Image(image: AssetImage('assets/dbriefLast.JPG'))),
                SizedBox(height: 35),
                Container(
                  child: Text(
                    "Get on top",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                Container(
                  child: Text(
                    "of the world today",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: ButtonTheme(
                    minWidth: 270,
                    height: 47.0,
                    child: RaisedButton(
                      color: Colors.orange[700],
                      //disabledColor: Colors.orange[700],
                      textColor: Colors.white,
                      //disabledTextColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                            fontSize: 16.0, // insert your font size here
                            fontWeight: FontWeight.bold),
                      ),

                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SecondPage(title: 'Sign Up Page')));
                      },
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                    width: 250,
                    margin: EdgeInsets.only(left: 40, right: 40),
                    child: Image(image: AssetImage('assets/dbriefLogo.JPG'))),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(left: 80, right: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("About"),
                      Text("FAQ"),
                      Text("Terms"),
                      Text("Privacy")
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Full Name",
                        filled: true,
                        fillColor: Color.fromARGB(68, 162, 159, 159),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Email",
                        filled: true,
                        fillColor: Color.fromARGB(68, 162, 159, 159),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Password",
                        filled: true,
                        fillColor: Color.fromARGB(68, 162, 159, 159),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Confirm Passoword",
                        filled: true,
                        fillColor: Color.fromARGB(68, 162, 159, 159),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ButtonTheme(
                    minWidth: 240,
                    height: 50.0,
                    child: RaisedButton(
                      color: Colors.orange[700],
                      disabledColor: Colors.orange[700],
                      textColor: Colors.white,
                      disabledTextColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('Register'),
                      onPressed: null,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ThirdPage(title: 'Sign In Page')));
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.orange,
                    ),
                    child: const Text('Already have an account?'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 40, right: 30),
                    child: Image(image: AssetImage('assets/dbriefLogo.JPG'))),
                Container(
                    width: 278,
                    margin: EdgeInsets.only(top: 30),
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 239, 238, 238)),
                    child: Column(children: [
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                            decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: "Email",
                          filled: true,
                          fillColor: Color.fromARGB(68, 162, 159, 159),
                        )),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: "Password",
                            filled: true,
                            fillColor: Color.fromARGB(68, 162, 159, 159),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: ButtonTheme(
                          minWidth: 270,
                          height: 50.0,
                          child: RaisedButton(
                            color: Colors.orange[700],
                            disabledColor: Colors.orange[700],
                            textColor: Colors.white,
                            disabledTextColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text('Login'),
                            onPressed: null,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SecondPage(title: 'Sign Up Page')));
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.orange,
                        ),
                        child: const Text("Don't have an account?"),
                      ),
                    ]))
              ]),
        ));
  }
}

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) =>
      isLogin ? LoginWidget() : SignUpWidget();

  void toggle() => setState(() => isLogin = !isLogin);
}
