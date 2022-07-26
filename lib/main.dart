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

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
  'email',
  //'https://www.googleapis.com/auth/contacts.readonly',
]);

String gUser = "";

class nextPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text("NEXT PAGE"),
    ));
  }
}

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
                                gUser = user.email;
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

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? HomePage()
      : Scaffold(
          appBar: AppBar(
            title: Text('Verify Email'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'A verification email has been sent to your email.',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  icon: Icon(Icons.email, size: 32),
                  label: Text(
                    'Resent Email',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                ),
                SizedBox(height: 8),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                )
              ],
            ),
          ),
        );
}

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

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
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
  Widget build(BuildContext context) => SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
          key: formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: 120),
            Container(
              margin: EdgeInsets.only(left: 40, right: 30),
              child: Image(image: AssetImage('assets/dbriefLogo.JPG')),
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
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Full Name',
                          filled: true,
                          fillColor: Color.fromARGB(68, 162, 159, 159)),
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
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'Email',
                            filled: true,
                            fillColor: Color.fromARGB(68, 162, 159, 159)),
                        controller: emailController,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.length < 8
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
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Confirm Password',
                          filled: true,
                          fillColor: Color.fromARGB(68, 162, 159, 159)),
                      controller: confirmPasswordController,
                      cursorColor: Colors.white,
                      textInputAction: TextInputAction.next,
                      validator: (value) => value != passwordController.text
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
                                  borderRadius: BorderRadius.circular(10))),
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
                  SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickedSignIn,
                          text: 'Already have an account?',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.orange[700]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ])));
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
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
  }

  postdata(String fullName, String authID) async {
    String fullName = fullNameController.text;
    var names = fullName.split(' ');
    String firstName = names[0];
    String lastName = names[1];

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
  }
}

class SignUpWidget2 extends StatefulWidget {
  const SignUpWidget2({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpWidget2State createState() => _SignUpWidget2State();
}

class _SignUpWidget2State extends State<SignUpWidget2> {
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
  Widget build(BuildContext context) => SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
          key: formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: 120),
            Container(
              margin: EdgeInsets.only(left: 40, right: 30),
              child: Image(image: AssetImage('assets/dbriefLogo.JPG')),
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
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Full Name',
                          filled: true,
                          fillColor: Color.fromARGB(68, 162, 159, 159)),
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
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'Email',
                            filled: true,
                            fillColor: Color.fromARGB(68, 162, 159, 159)),
                        controller: emailController,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.length < 8
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
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Confirm Password',
                          filled: true,
                          fillColor: Color.fromARGB(68, 162, 159, 159)),
                      controller: confirmPasswordController,
                      cursorColor: Colors.white,
                      textInputAction: TextInputAction.next,
                      validator: (value) => value != passwordController.text
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
                                  borderRadius: BorderRadius.circular(10))),
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
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ])));
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
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
  }

  postdata(String fullName, String authID) async {
    String fullName = fullNameController.text;
    var names = fullName.split(' ');
    String firstName = names[0];
    String lastName = names[1];

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
  }
}

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
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
  Widget build(BuildContext context) => SingleChildScrollView(
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
                    child: RichText(
                      textScaleFactor:
                          MediaQuery.of(context).textScaleFactor + 0.15,
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignUp,
                            text: "Don't have an account?",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.orange[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            )
          ]));
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
  final bool isLogin = true;

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

class fifthPage extends StatefulWidget {
  const fifthPage({Key? key}) : super(key: key);

  @override
  State<fifthPage> createState() => _fifthPageState();
}

class _fifthPageState extends State<fifthPage> {
  GoogleSignInAccount? _currentUser;

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((event) {
      setState(() {
        _currentUser = event;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(_currentUser == null ? 'Login' : 'Dashboard')),
        body: _currentUser == null
            ? Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Container(
                        width: 200,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueGrey),
                            onPressed: () => _handleSignIn(),
                            child: Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Sign in with google Test'),
                                  ],
                                ))))
                  ]))
            : Container(
                child: ListTile(
                  leading: GoogleUserCircleAvatar(identity: _currentUser!),
                  title: Text(_currentUser!.displayName ?? ''),
                  subtitle: Text(_currentUser!.email),
                  trailing: IconButton(
                    onPressed: () {
                      _googleSignIn.disconnect();
                    },
                    icon: Icon(Icons.logout),
                  ),
                ),
              ));
  }
}

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

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(onClickedSignUp: toggle)
      : SignUpWidget(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
