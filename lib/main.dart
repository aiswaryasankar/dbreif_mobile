import 'dart:async';
import 'dart:collection';
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
import 'package:flutter_application_1/mainHomePage.dart';

var user = new Map();
var topicData = new Map();
var ans;
var TimelineDict = new Map();
var newTimelineDict = new Map();
var finalTimelineDict = new Map();
var TimelineDictAuthor = new Map();
var newTimelineDictAuthor = new Map();
var finalTimelineDictAuthor = new Map();
var temp;
var timeLineDates = [];
var mainPageDates = [];

Future<void> setData(String email, String name, String AuthCode) async {
  final SharedPreferences gPref = await SharedPreferences.getInstance();
  gPref.setString('email', email);
  gPref.setString('name', name);
  gPref.setString('authCode', AuthCode);
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

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final bool isLoggedIn = false;

  void initState() {
    getTopicPages("uber");
    hydrateHomePage('1');
    sortByDate();
    setState(() {});
    print(3);
    print(10000);
    formatMainPageDates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 100),
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
                    'HYDRATE',
                    style: TextStyle(
                        fontSize: 16.0, // insert your font size here
                        fontWeight: FontWeight.bold),
                  ),

                  onPressed: () {
                    hydrateHomePage('1');
                  },
                ),
              ),
            ),
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
                    'FORMAT',
                    style: TextStyle(
                        fontSize: 16.0, // insert your font size here
                        fontWeight: FontWeight.bold),
                  ),

                  onPressed: () {
                    formatMainPageDates();
                  },
                ),
              ),
            ),
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
                    mainPageDates.length.toString(),
                    style: TextStyle(
                        fontSize: 16.0, // insert your font size here
                        fontWeight: FontWeight.bold),
                  ),

                  onPressed: () {
                    getTopicPages("uber");
                  },
                ),
              ),
            ),
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
                    'Go to Main Home Page',
                    style: TextStyle(
                        fontSize: 16.0, // insert your font size here
                        fontWeight: FontWeight.bold),
                  ),

                  onPressed: () {
                    hydrateHomePage('1');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => mainHomePage()));
                  },
                ),
              ),
            ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'story',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'in',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'seconds',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.orange),
                  )
                ],
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
                    'getTopic',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    getTopicPages('Text');
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
                    var user = FirebaseAuth.instance.currentUser?.emailVerified;
                    user != null
                        ? Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HomePage()))
                        : Navigator.push(
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
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
              ),
            ),
            Container(
              child: Text(
                "the art research to search, summarie, and organize",
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
              ),
            ),
            Container(
              child: Text(
                "news contect across all platforms",
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
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
                  onPressed: () {},
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
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ))),
            Container(
                width: 700.0,
                child: Center(
                    child: Text(
                  'articles, shows and content yourself',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
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

                  onPressed: () {},
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
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ))),
                Container(
                    width: 700.0,
                    child: Center(
                        child: Text(
                      'holistic vantage point wherever you are',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
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

                      onPressed: () {},
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
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ))),
                Container(
                    width: 700.0,
                    child: Center(
                        child: Text(
                      'Choose your preferred sources.',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ))),
                SizedBox(height: 20),
                Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: Image(image: AssetImage('assets/dbriefThree.JPG'))),
                SizedBox(height: 50),
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
                        var user =
                            FirebaseAuth.instance.currentUser?.emailVerified;
                        user != null
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()))
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpWidget()));
                      },
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                    width: 220,
                    margin: EdgeInsets.only(left: 40, right: 40),
                    child: Image(image: AssetImage('assets/dbriefLogo.JPG'))),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(left: 80, right: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("About",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("FAQ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Terms",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Privacy",
                          style: TextStyle(fontWeight: FontWeight.bold))
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

getTopicPages(String text) async {
  var response = await http.post(
      Uri.parse(
          "http://infra.eba-ydmy6xs3.us-west-2.elasticbeanstalk.com/getTopicPage/?Content-Type=application/json&Accept=application/json, text/plain, /"),
      headers: {
        "Content-type": "application/json; charset=utf-8",
        "Accept": "application/json"
      },
      body: jsonEncode({
        "text": "California",
      }));

  print("testing");
  print(response.body);
  print(response.body.substring(18, response.body.length - 19));
  var resultingString = response.body.substring(18, response.body.length - 19);

  print("break");
  String raw = resultingString.replaceAll(r'\\\"', "'");
  String resulting = raw.replaceAll(r'\"', '"');
  String one = resulting.replaceAll(r'\\u2019', '\u2019');
  String two = one.replaceAll(r'\\u201c', '\u201c');
  String three = two.replaceAll(r'\\u201d', '\u201d');
  String four = three.replaceAll(r'\\u2014', '\u2014');
  String five = four.replaceAll(r'\\u00e9', '\u00e9');

  topicData = jsonDecode(five);
  print(topicData);
  // print(topicData['Facts'].length);
  // print(topicData['Facts'][0]);
  // print(topicData["Facts"][0]["Quote"]["Text"]);
  //print(resultingString);

  print("TOPICDATA DICOBA");
  print("DAPET TOPICDATA");
  for (var i = 0; i < topicData["Opinions"].length; i++) {
    if (timeLineDates
        .contains(topicData["Opinions"][i]["Quote"]["Timestamp"])) {
      continue;
    } else {
      timeLineDates.add(topicData["Opinions"][i]["Quote"]["Timestamp"]);
    }
  }

  // print("Break");
  // print(timeLineDates);
  print("TIMELINEDATES DICOBA");
  for (var i = 0; i < timeLineDates.length; i++) {
    var splitted = timeLineDates[i].split(" ");

    timeLineDates[i] = splitted[0];
  }
  print(timeLineDates);
  print("Second Break");
  TimelineDict.clear();
  newTimelineDict.clear();
  finalTimelineDict.clear();
  TimelineDictAuthor.clear();
  newTimelineDictAuthor.clear();
  finalTimelineDictAuthor.clear();

  for (var i = 0; i < topicData["Opinions"].length; i++) {
    var dummy = TimelineDict[topicData["Opinions"][i]["Quote"]["Timestamp"]];

    dummy == null
        ? TimelineDict[topicData["Opinions"][i]["Quote"]["Timestamp"]] = [
            topicData["Opinions"][i]["Quote"]["Text"]
          ]
        : {
            dummy.add(topicData["Opinions"][i]["Quote"]["Text"]),
            TimelineDict[topicData["Opinions"][i]["Quote"]["Timestamp"]] = dummy
          };
  }
  //author
  for (var i = 0; i < topicData["Opinions"].length; i++) {
    var dummy =
        TimelineDictAuthor[topicData["Opinions"][i]["Quote"]["Timestamp"]];

    dummy == null
        ? TimelineDictAuthor[topicData["Opinions"][i]["Quote"]["Timestamp"]] = [
            topicData["Opinions"][i]["Quote"]["Author"]
          ]
        : {
            dummy.add(topicData["Opinions"][i]["Quote"]["Author"]),
            TimelineDictAuthor[topicData["Opinions"][i]["Quote"]["Timestamp"]] =
                dummy
          };
  }

  // print(TimelineDict);
  // print("third break");
  print("TIMELINEDICT DICOBA");
  for (var i = 0; i < TimelineDict.length; i++) {
    var dummy = TimelineDict.keys.elementAt(i);
    var split = dummy.split(" ");
    //print("Sepelit");
    //print(split[0]);
    var subString = split[0].substring(5);
    //print(subString);
    newTimelineDict[subString] = TimelineDict[dummy];
  }
  //author
  print("TIMELINEAUTHOR DICOBA");
  for (var i = 0; i < TimelineDictAuthor.length; i++) {
    var dummy = TimelineDictAuthor.keys.elementAt(i);
    var split = dummy.split(" ");
    // print("Sepelit");
    // print(split[0]);
    var subString = split[0].substring(5);
    //print(subString);
    newTimelineDictAuthor[subString] = TimelineDictAuthor[dummy];
  }

  // print("Fourth break");
  // print(newTimelineDict);
  var testIndex = newTimelineDict.keys.elementAt(0);
  //print(newTimelineDict[testIndex]);

  print("NEWTIMELINEDICT DICOBA");
  for (var i = 0; i < newTimelineDict.length; i++) {
    var firstString;
    var secondString;
    var dummy = newTimelineDict.keys.elementAt(i);
    var split = dummy.split("-");
    // print("kedua");
    // print(split);
    if (split[0] == '01') {
      firstString = "January";
    }
    if (split[0] == '02') {
      firstString = "February";
    }
    if (split[0] == '03') {
      firstString = "March";
    }
    if (split[0] == '04') {
      firstString = "April";
    }
    if (split[0] == '05') {
      firstString = "May";
    }
    if (split[0] == '06') {
      firstString = "June";
    }
    if (split[0] == '07') {
      firstString = "July";
    }
    if (split[0] == '08') {
      firstString = "August";
    }
    if (split[0] == '09') {
      firstString = "September";
    }
    if (split[0] == '10') {
      firstString = "October";
    }
    if (split[0] == '11') {
      firstString = "November";
    }
    if (split[0] == '12') {
      firstString = "December";
    }

    var resultingString = firstString + " " + split[1];
    finalTimelineDict[resultingString] = newTimelineDict[dummy];
  }
  //author
  print("NEWTIMELINEDICTAUTHOR DICOBA");
  for (var i = 0; i < newTimelineDictAuthor.length; i++) {
    var firstString;
    var secondString;
    var dummy = newTimelineDictAuthor.keys.elementAt(i);
    var split = dummy.split("-");
    // print("kedua");
    // print(split);
    if (split[0] == '01') {
      firstString = "January";
    }
    if (split[0] == '02') {
      firstString = "February";
    }
    if (split[0] == '03') {
      firstString = "March";
    }
    if (split[0] == '04') {
      firstString = "April";
    }
    if (split[0] == '05') {
      firstString = "May";
    }
    if (split[0] == '06') {
      firstString = "June";
    }
    if (split[0] == '07') {
      firstString = "July";
    }
    if (split[0] == '08') {
      firstString = "August";
    }
    if (split[0] == '09') {
      firstString = "September";
    }
    if (split[0] == '10') {
      firstString = "October";
    }
    if (split[0] == '11') {
      firstString = "November";
    }
    if (split[0] == '12') {
      firstString = "December";
    }

    var resultingString = firstString + " " + split[1];
    finalTimelineDictAuthor[resultingString] = newTimelineDictAuthor[dummy];
  }
  //print(finalTimelineDict.length);
  print(finalTimelineDict);
  print('Kumpul');
}

sortByDate() {
  print(finalTimelineDict);
  temp = finalTimelineDict.keys.toList();
  temp.sort();
  print(temp);
  print("TEMP DICOBA");
  for (var i = 0; i < temp.length; i++) {
    if (temp[i].contains("January")) {
      temp[i] = "1" + "  " + temp[i];
    }
    if (temp[i].contains("Februaru")) {
      temp[i] = "2" + "  " + temp[i];
    }
    if (temp[i].contains("March")) {
      temp[i] = "3" + "  " + temp[i];
    }
    if (temp[i].contains("April")) {
      temp[i] = "4" + "  " + temp[i];
    }
    if (temp[i].contains("May")) {
      temp[i] = "5" + "  " + temp[i];
    }
    if (temp[i].contains("June")) {
      temp[i] = "6" + "  " + temp[i];
    }
    if (temp[i].contains("July")) {
      temp[i] = "7" + "  " + temp[i];
    }
    if (temp[i].contains("August")) {
      temp[i] = "8" + "  " + temp[i];
    }
    if (temp[i].contains("September")) {
      temp[i] = "9" + "  " + temp[i];
    }
    if (temp[i].contains("Octomber")) {
      temp[i] = "10" + " " + temp[i];
    }
    if (temp[i].contains("November")) {
      temp[i] = "11" + " " + temp[i];
    }
    if (temp[i].contains("December")) {
      temp[i] = "12" + " " + temp[i];
    }
  }
  temp.sort();
  print(temp);

  for (var i = 0; i < temp.length; i++) {
    temp[i] = temp[i].substring(3);
  }
  print(temp);
}

hydrateHomePage(String text) async {
  var response = await http.post(
      Uri.parse(
          "https://ddbrief.com/hydrateHomePage/?Content-Type=application/json&Accept=application/json, text/plain, /"),
      headers: {
        "Content-type": "application/json; charset=utf-8",
        "Accept": "application/json"
      },
      body: jsonEncode({
        "userId": 1,
      }));

  var homePageString = response.body.substring(18, response.body.length - 19);

  print(homePageString.runtimeType);

  String raw = homePageString.replaceAll(r'\\\"', "'");
  String resulting = raw.replaceAll(r'\"', '"');
  String one = resulting.replaceAll(r'\\u2019', '\u2019');
  String two = one.replaceAll(r'\\u201c', '\u201c');
  String three = two.replaceAll(r'\\u201d', '\u201d');
  String four = three.replaceAll(r'\\u2014', '\u2014');
  String five = four.replaceAll(r'\\u00e9', '\u00e9');
  String six = five.replaceAll(r'\\u2013', '\u2013');
  String seven = six.replaceAll(r"['", '');
  String eight = seven.replaceAll(r"']", '');

  homePageList = jsonDecode(eight);
  print(homePageList.runtimeType);

  for (var i = 0; i < topicData["Opinions"].length; i++) {
    if (timeLineDates
        .contains(topicData["Opinions"][i]["Quote"]["Timestamp"])) {
      continue;
    } else {
      timeLineDates.add(topicData["Opinions"][i]["Quote"]["Timestamp"]);
    }
  }
  print(homePageList[0]["topic_page"]["Title"]);
  print("HOMEPAGE UDA");
  // print("Break");
  // print(timeLineDates);

  for (var i = 0; i < timeLineDates.length; i++) {
    var splitted = timeLineDates[i].split(" ");

    timeLineDates[i] = splitted[0];
  }
  print(timeLineDates);
  print("Second Break");
  TimelineDict.clear();
  newTimelineDict.clear();
  finalTimelineDict.clear();
  TimelineDictAuthor.clear();
  newTimelineDictAuthor.clear();
  finalTimelineDictAuthor.clear();

  for (var i = 0; i < topicData["Opinions"].length; i++) {
    var dummy = TimelineDict[topicData["Opinions"][i]["Quote"]["Timestamp"]];

    dummy == null
        ? TimelineDict[topicData["Opinions"][i]["Quote"]["Timestamp"]] = [
            topicData["Opinions"][i]["Quote"]["Text"]
          ]
        : {
            dummy.add(topicData["Opinions"][i]["Quote"]["Text"]),
            TimelineDict[topicData["Opinions"][i]["Quote"]["Timestamp"]] = dummy
          };
  }
  //author
  for (var i = 0; i < topicData["Opinions"].length; i++) {
    var dummy =
        TimelineDictAuthor[topicData["Opinions"][i]["Quote"]["Timestamp"]];

    dummy == null
        ? TimelineDictAuthor[topicData["Opinions"][i]["Quote"]["Timestamp"]] = [
            topicData["Opinions"][i]["Quote"]["Author"]
          ]
        : {
            dummy.add(topicData["Opinions"][i]["Quote"]["Author"]),
            TimelineDictAuthor[topicData["Opinions"][i]["Quote"]["Timestamp"]] =
                dummy
          };
  }

  // print(TimelineDict);
  // print("third break");

  for (var i = 0; i < TimelineDict.length; i++) {
    var dummy = TimelineDict.keys.elementAt(i);
    var split = dummy.split(" ");
    //print("Sepelit");
    //print(split[0]);
    var subString = split[0].substring(5);
    //print(subString);
    newTimelineDict[subString] = TimelineDict[dummy];
  }
  //author
  for (var i = 0; i < TimelineDictAuthor.length; i++) {
    var dummy = TimelineDictAuthor.keys.elementAt(i);
    var split = dummy.split(" ");
    // print("Sepelit");
    // print(split[0]);
    var subString = split[0].substring(5);
    //print(subString);
    newTimelineDictAuthor[subString] = TimelineDictAuthor[dummy];
  }

  // print("Fourth break");
  // print(newTimelineDict);
  var testIndex = newTimelineDict.keys.elementAt(0);
  //print(newTimelineDict[testIndex]);

  for (var i = 0; i < newTimelineDict.length; i++) {
    var firstString;
    var secondString;
    var dummy = newTimelineDict.keys.elementAt(i);
    var split = dummy.split("-");
    // print("kedua");
    // print(split);
    if (split[0] == '01') {
      firstString = "January";
    }
    if (split[0] == '02') {
      firstString = "February";
    }
    if (split[0] == '03') {
      firstString = "March";
    }
    if (split[0] == '04') {
      firstString = "April";
    }
    if (split[0] == '05') {
      firstString = "May";
    }
    if (split[0] == '06') {
      firstString = "June";
    }
    if (split[0] == '07') {
      firstString = "July";
    }
    if (split[0] == '08') {
      firstString = "August";
    }
    if (split[0] == '09') {
      firstString = "September";
    }
    if (split[0] == '10') {
      firstString = "October";
    }
    if (split[0] == '11') {
      firstString = "November";
    }
    if (split[0] == '12') {
      firstString = "December";
    }

    var resultingString = firstString + " " + split[1];
    finalTimelineDict[resultingString] = newTimelineDict[dummy];
  }
  //author
  for (var i = 0; i < newTimelineDictAuthor.length; i++) {
    var firstString;
    var secondString;
    var dummy = newTimelineDictAuthor.keys.elementAt(i);
    var split = dummy.split("-");
    // print("kedua");
    // print(split);
    if (split[0] == '01') {
      firstString = "January";
    }
    if (split[0] == '02') {
      firstString = "February";
    }
    if (split[0] == '03') {
      firstString = "March";
    }
    if (split[0] == '04') {
      firstString = "April";
    }
    if (split[0] == '05') {
      firstString = "May";
    }
    if (split[0] == '06') {
      firstString = "June";
    }
    if (split[0] == '07') {
      firstString = "July";
    }
    if (split[0] == '08') {
      firstString = "August";
    }
    if (split[0] == '09') {
      firstString = "September";
    }
    if (split[0] == '10') {
      firstString = "October";
    }
    if (split[0] == '11') {
      firstString = "November";
    }
    if (split[0] == '12') {
      firstString = "December";
    }

    var resultingString = firstString + " " + split[1];
    finalTimelineDictAuthor[resultingString] = newTimelineDictAuthor[dummy];
  }
  print("ini homepagelist");
  print(homePageList.length);
}

formatMainPageDates() async {
  for (var i = 0; i < homePageList.length; i++) {
    var dummy = homePageList[i]["topic_page"]["CreatedAt"];
    var split = dummy.split(" ");
    print(homePageList[i]["topic_page"]["CreatedAt"]);

    var split1 = split[0];
    var split2 = split1.split("-");
    var firstString;

    if (split2[2] == '01') {
      firstString = "January";
    }
    if (split2[2] == '02') {
      firstString = "February";
    }
    if (split2[2] == '03') {
      firstString = "March";
    }
    if (split2[2] == '04') {
      firstString = "April";
    }
    if (split2[2] == '05') {
      firstString = "May";
    }
    if (split2[2] == '06') {
      firstString = "June";
    }
    if (split2[2] == '07') {
      firstString = "July";
    }
    if (split2[2] == '08') {
      firstString = "August";
    }
    if (split2[2] == '09') {
      firstString = "September";
    }
    if (split2[2] == '10') {
      firstString = "October";
    }
    if (split2[2] == '11') {
      firstString = "November";
    }
    if (split2[2] == '12') {
      firstString = "December";
    }
    print("BIS");
    print(mainPageDates);

    var finalString = split2[1] + " " + firstString;
    print(finalString);
    mainPageDates.add(finalString);
  }
  print("OKE");
}
