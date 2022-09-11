import 'dart:async';
import 'dart:convert';
import 'dart:convert' show utf8;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_application_1/mainHomePage.dart';
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
  String? gAuthCode;

  final searchController = TextEditingController();

  var factsList = [
    [
      "Presiden Joe Biden: What you need to know Coronavirus: White House must go further on new pandemic response, say former Biden advisers, outside expers Fact checker: The false and misleading claims Biden made during his first 100 days in office The Biden cabiner: Who has been selected Biden appointess: Who is filling key roles",
      "Washington Post"
    ],
    [
      'Joe Biden gets upset when you gquote Joe Biden to Joe Biden, "Bongino said, adding that it may indeed be the time to consider replacing Biden in the line of sucession -- while also contemplating the competency of the next-in-line, Vice Presiden Kamala Harris',
      "Jakarta Post"
    ]
  ];
  var timelineList = [
    [
      ["July 30"],
      [
        "Rep. Adriano Espailat (D-NY) writes, prior to the covid-19 pandemic, 96 percent of DACA recipients were employed or enrolled in school, slowly but surely entering our workforce pipleine to become our future educators, helath care professionals, public servans and community leaders. Nearly 25 percent of recipients also have children who are U.S citizens...",
        "Adriano Espaillat, The Hill"
      ],
      [
        "Democrats have advocated a pathway to citizenship for illegal immigrants for decades now, but never have they said that we must create one primarily as a budgetary matter -- as if the status of illegal immigrants is a question comparable to the level of Medicare hospital reimbursements or unemployment benefits...",
        "The Editors, National Review"
      ]
    ],
    [
      ["July 29"],
      [
        "The democrats wants to include a massive amnesty in that legislation, '[stated] Sen. Tom Cotton (R-Ark.). 'That will simply act as a bigger magnet for more illegal immigration into this country.' This is nonsense. The population eligible for legalization would likely be restricted to people who've already been here.",
        "Catharine Lampell, Washington Post"
      ],
    ]
  ];

  var timeLineDates = [];

  int factCounter = 0;
  @override
  void initState() {
    setState(() {});
    super.initState();
    getData();
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
              child: gAuthCode == null ? Text('No Data') : Text(gAuthCode!),
            ),
            SizedBox(height: 15),
            Container(
                child: Column(
              children: [
                // Text(user['FirebaseAuthID']),
                // Text(user['FirstName']),
                // Text(user['LastName']),
                // Text(user['Email']),
              ],
            )),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => mainHomePage()));
                  },
                ),
              ),
            ),
            Container(
                child: const Text(
                    "----------------------------------------------------------------------------------------------")),
            Container(
              child: ButtonTheme(
                minWidth: 40,
                height: 40,
                child: RaisedButton(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  color: Colors.grey[300],
                  textColor: Colors.grey[600],
                  //Quit Icon/Button
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Text('getTopicPage'),

                  onPressed: () {
                    getTopicPage(1);
                  },
                ),
              ),
            ),
            Container(
              child: ButtonTheme(
                minWidth: 40,
                height: 40,
                child: RaisedButton(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  color: Colors.grey[300],
                  textColor: Colors.grey[600],
                  //Quit Icon/Button
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Text('HYDRATE'),

                  onPressed: () {
                    hydrateHomePage("1");
                  },
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: Colors.grey[350],
                    //The Search Bar
                    labelText: "Enter a keyword or paste an article link"),
                cursorColor: Colors.green,
                controller: searchController,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    height: MediaQuery.of(context).size.height / 1000),
              ),
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/dbriefLogoSolo.JPG',
                      scale: 0.7,
                    ),
                  ),
                ),
                SizedBox(width: 155),
                Container(
                  child: ButtonTheme(
                    minWidth: 40,
                    height: 40,
                    child: RaisedButton(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      color: Colors.grey[300],
                      textColor: Colors.grey[600],
                      //Quit Icon/Button
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Icon(
                        Icons.close,
                        color: Colors.black12.withOpacity(0.5),
                      ),

                      onPressed: () {},
                    ),
                  ),
                ),
                SizedBox(width: 0),
                //Person Icon/Button
                ButtonTheme(
                  minWidth: 60,
                  height: 60,
                  child: Container(
                    child: TextButton(
                      child: Icon(
                        Icons.person_pin,
                        color: Colors.black.withOpacity(0.1),
                        size: 80,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            //title container
            Container(
                margin: EdgeInsets.only(left: 20),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: topicData == null
                        ? Text(
                            'Second gentleman Doug Emhoff tests positive for the coronavirus',
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 23),
                          )
                        : Text(
                            topicData['Title'],
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 23),
                          ))),
            SizedBox(height: 20),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 239, 238, 238)),
                child: Column(children: [
                  SizedBox(height: 20),
                  //image container
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: topicData == null
                              ? NetworkImage(
                                  "https://www.whitehouse.gov/wp-content/uploads/2021/04/P20210303AS-1901-cropped.jpg?resize=768,576")
                              : NetworkImage(topicData['ImageURL'])),
                    ),
                  ),
                  SizedBox(height: 20),
                  //summary container
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: topicData == null
                              ? Text(
                                  "Hey Joe Biden, what would be the long-term effect in the United States of what you're doing? No idea. Dont't have to think about the future now, when everything is suddenly at stake, There's never been recklessness at this level in the White House and yes, that includes the last president who was often attacked for being reckless. Nothing he said compares to this. Fox's Peter Doocy asked for clarification and response. Joe Biden revealed that he is completely unaware that his staff has been continously updating American policy all week as he changes it on the fly. Watch Joe Biden:",
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                )
                              : Text(
                                  topicData['MDSSummary'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ))),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      //following button
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: ButtonTheme(
                          minWidth:
                              (MediaQuery.of(context).size.width - 40) / 2 - 40,
                          height: 35.0,
                          child: RaisedButton(
                            color: Colors.orange[700],
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Following',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0, // insert your font size here
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      //share button
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: ButtonTheme(
                          minWidth:
                              (MediaQuery.of(context).size.width - 40) / 2 - 40,
                          height: 35.0,
                          child: RaisedButton(
                            color: Colors.grey[300],
                            textColor: Colors.grey[600],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Share',
                              style: TextStyle(
                                  fontSize: 20.0, // insert your font size here
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  //learn more button / Hyperlink
                  Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Wrap(
                        children: [
                          Container(
                            child: Text(
                              "This ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "is ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "an ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "auto-generated ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "summary ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "from ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "articles ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "all ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "over ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "the ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "internet ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "so ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "you ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "don't ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "miss ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "a thing. ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 0.1),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black.withOpacity(0.6),
                                        width: 0.8))),
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: 'Learn more',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print(3);
                                    })
                            ])),
                          )
                        ],
                      )),
                ])),
            SizedBox(height: 20),
            Row(children: [
              //unknown Icon
              Container(
                margin: EdgeInsets.only(left: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ButtonTheme(
                    minWidth: 0,
                    height: 30,
                    child: RaisedButton(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      color: Colors.grey[300],
                      textColor: Colors.grey[600],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        Icons.safety_check,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: Text(
                    'Facts',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 23),
                  )),
                  Container(
                    child: Text(
                      "Key information from trusted sources.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ]),
            SizedBox(height: 15),

            for (var i = 0; i < 5; i++) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 48),
                    child: ButtonTheme(
                      minWidth: 0,
                      height: 9.0,
                      child: RaisedButton(
                        padding: EdgeInsets.only(left: 7, right: 7),
                        color: Colors.grey[300],
                        textColor: Colors.grey[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          (i + 1).toString(),
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Fact #1
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Text(
                            topicData["Facts"][i]["Quote"]["Text"],
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                        ),
                        SizedBox(height: 5),

                        //Source hyperlink #1
                        Container(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.logout,
                                color: Colors.orange,
                              ),
                              label: Text(
                                topicData["Facts"][i]["Quote"]["Author"],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 10),

            Container(
              child: ButtonTheme(
                  child: TextButton(
                child: Text('Sort'),
                onPressed: sortByDate,
              )),
            ),

            SizedBox(height: 20),

            for (var t = 0; t < temp.length; t++) ...[
              for (var i = 0; i < finalTimelineDict.length; i++) ...[
                finalTimelineDict.keys.elementAt(i).toString() == temp[t]
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Column(children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        finalTimelineDict.keys
                                            .elementAt(i)
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  for (var j = 0;
                                      j <
                                          finalTimelineDict[finalTimelineDict
                                                  .keys
                                                  .elementAt(i)]
                                              .length;
                                      j++) ...[
                                    Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            // margin: EdgeInsets.only(left: 20, right: 20),
                                            child: ButtonTheme(
                                              minWidth: 30.0,
                                              height: 30.0,
                                              child: RaisedButton(
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                color: Colors.orange[700],
                                                //disabledColor: Colors.orange[700],
                                                textColor: Colors.white,
                                                //disabledTextColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Text(
                                                  (j + 1).toString(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          15.0, // insert your font size here
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                onPressed: () {},
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 +
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5,
                                          decoration: new BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color.fromARGB(
                                                  255, 239, 238, 238)),
                                          child: Column(
                                            children: [
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      top: 10,
                                                      left: 20,
                                                      right: 20),
                                                  child: Text(
                                                    finalTimelineDict[
                                                            finalTimelineDict
                                                                .keys
                                                                .elementAt(i)]
                                                        .join(',')
                                                        .toString(),
                                                    overflow: TextOverflow.clip,
                                                  )),
                                              SizedBox(height: 10),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 20),
                                                  child: Text(
                                                    finalTimelineDictAuthor[
                                                            finalTimelineDictAuthor
                                                                .keys
                                                                .elementAt(
                                                                    i)][j]
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.orange,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                  SizedBox(height: 20),
                                ]))))
                    : Container()
              ],
            ],
          ],
        ),
      ),
    );
  }

  void getData() async {
    final SharedPreferences gPref = await SharedPreferences.getInstance();
    gEmail = gPref.getString('email');
    gName = gPref.getString('name');
    gAuthCode = gPref.getString('authCode');

    var response = await http.post(
        Uri.parse(
            "https://ddbrief.com/getUser/?Content-Type=application/json&Accept=application/json,text/plain,/"),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode({
          "firebaseAuthId": gAuthCode,
        }));

    var resultingString =
        response.body.substring(11, response.body.length - 19);

    String resulting = resultingString.replaceAll(r'\"', '"');
    user = jsonDecode(resulting);

    setState(() {});
  }

  incrementFactCounter() {
    factCounter += 1;
    setState(() {});
  }

  getTopicPage(int text) async {
    var response = await http.post(
        Uri.parse(
            "http://infra.eba-ydmy6xs3.us-west-2.elasticbeanstalk.com/getTopicPage/?Content-Type=application/json&Accept=application/json, text/plain, /"),
        headers: {
          "Content-type": "application/json; charset=utf-8",
          "Accept": "application/json"
        },
        body: jsonEncode({
          "articleId": text,
        }));

    var resultingString =
        response.body.substring(18, response.body.length - 19);

    String raw = resultingString.replaceAll(r'\\\"', "'");
    String resulting = raw.replaceAll(r'\"', '"');
    String one = resulting.replaceAll(r'\\u2019', '\u2019');
    String two = one.replaceAll(r'\\u201c', '\u201c');
    String three = two.replaceAll(r'\\u201d', '\u201d');
    String four = three.replaceAll(r'\\u2014', '\u2014');
    String five = four.replaceAll(r'\\u00e9', '\u00e9');

    topicData = jsonDecode(five);
    // print(topicData['Facts'].length);
    // print(topicData['Facts'][0]);
    // print(topicData["Facts"][0]["Quote"]["Text"]);
    //print(resultingString);

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
              TimelineDict[topicData["Opinions"][i]["Quote"]["Timestamp"]] =
                  dummy
            };
    }
    //author
    for (var i = 0; i < topicData["Opinions"].length; i++) {
      var dummy =
          TimelineDictAuthor[topicData["Opinions"][i]["Quote"]["Timestamp"]];

      dummy == null
          ? TimelineDictAuthor[topicData["Opinions"][i]["Quote"]["Timestamp"]] =
              [topicData["Opinions"][i]["Quote"]["Author"]]
          : {
              dummy.add(topicData["Opinions"][i]["Quote"]["Author"]),
              TimelineDictAuthor[topicData["Opinions"][i]["Quote"]
                  ["Timestamp"]] = dummy
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
    //print(finalTimelineDict.length);
    print(finalTimelineDict);
    print('Kumpul');
  }

  sortByDate() {
    print(finalTimelineDict);
    temp = finalTimelineDict.keys.toList();
    temp.sort();
    print(temp);
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
    setState(() {});
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
              TimelineDict[topicData["Opinions"][i]["Quote"]["Timestamp"]] =
                  dummy
            };
    }
    //author
    for (var i = 0; i < topicData["Opinions"].length; i++) {
      var dummy =
          TimelineDictAuthor[topicData["Opinions"][i]["Quote"]["Timestamp"]];

      dummy == null
          ? TimelineDictAuthor[topicData["Opinions"][i]["Quote"]["Timestamp"]] =
              [topicData["Opinions"][i]["Quote"]["Author"]]
          : {
              dummy.add(topicData["Opinions"][i]["Quote"]["Author"]),
              TimelineDictAuthor[topicData["Opinions"][i]["Quote"]
                  ["Timestamp"]] = dummy
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
  }
}
