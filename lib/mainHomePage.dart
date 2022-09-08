import 'dart:async';
import 'dart:convert';
import 'dart:convert' show utf8;

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

var timeLineDates = [];

class mainHomePage extends StatefulWidget {
  const mainHomePage({Key? key}) : super(key: key);

  @override
  State<mainHomePage> createState() => _mainHomePageState();
}

var homePageList;

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
}

class _mainHomePageState extends State<mainHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var i = 0; i < homePageList.length; i++) ...[
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 239, 238, 238)),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width - 80,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                homePageList[i]["topic_page"]["ImageURL"])),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                                homePageList[i]["topic_page"]["TopicName"]),
                          ),
                          SizedBox(width: 130),
                          Container(
                            child: Text('28 AUGUST'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              homePageList[i]["topic_page"]['Title'],
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 23),
                            ))),
                    SizedBox(height: 20),
                    Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              homePageList[i]["topic_page"]['MDSSummary'],
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            ))),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: ButtonTheme(
                          minWidth: 100,
                          height: 35.0,
                          child: RaisedButton(
                            color: Colors.orange[700],
                            //disabledColor: Colors.orange[700],
                            textColor: Colors.white,
                            //disabledTextColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Read Full Story',
                              style: TextStyle(
                                  fontSize: 16.0, // insert your font size here
                                  fontWeight: FontWeight.bold),
                            ),

                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: Divider(
                        color: Colors.grey,
                        height: 20,
                        thickness: 2,
                        indent: 30,
                        endIndent: 30,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
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
                                '1',
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w500),
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
                                  homePageList[i]["topic_page"]["Facts"][0]
                                      ["Quote"]["Text"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),

                              //Source hyperlink #1
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        homePageList[i]["topic_page"]["Facts"]
                                            [0]["Quote"]["Author"],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
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
                                '2',
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //Fact #1
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Text(
                                  homePageList[i]["topic_page"]["Facts"][1]
                                      ["Quote"]["Text"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                              //Source hyperlink #1
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      homePageList[i]["topic_page"]["Facts"][1]
                                          ["Quote"]["Author"],
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
                ),
              ),
              SizedBox(height: 30),
            ],

            SizedBox(height: 200),

            //STOPPPPPPP

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

            SizedBox(height: 100),

            SizedBox(height: 40),
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
                    'Hydrate Home Page',
                    style: TextStyle(
                        fontSize: 16.0, // insert your font size here
                        fontWeight: FontWeight.bold),
                  ),

                  onPressed: () {
                    hydrateHomePage("1");
                  },
                ),
              ),
            ),
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
                        Icons.search_rounded,
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
            SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20),
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 239, 238, 238)),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "https://source.unsplash.com/random/200x200?sig=4")),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Container(
                          child: Text('BIPARTISANSHIP'),
                        ),
                        SizedBox(width: 130),
                        Container(
                          child: Text('28 AUGUST'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'The Manchin-Schumer infrastructure bill faces a crucial vote in the House on Friday amid fears that moderate Democrats will withhold thier support.',
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 23),
                          ))),
                  SizedBox(height: 20),
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "-- The House is set to vote Friday on a massive 1.1 trillion spending bill that would keep the government running through september--and it's not clear whether Democrats will be among those voting in favor. A number of high-profile holdouts had expressed concerns, including one Democrat who said he was 'troubled' by i... ",
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ))),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: ButtonTheme(
                        minWidth: 100,
                        height: 35.0,
                        child: RaisedButton(
                          color: Colors.orange[700],
                          //disabledColor: Colors.orange[700],
                          textColor: Colors.white,
                          //disabledTextColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Read Full Story',
                            style: TextStyle(
                                fontSize: 16.0, // insert your font size here
                                fontWeight: FontWeight.bold),
                          ),

                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Divider(
                      color: Colors.grey,
                      height: 20,
                      thickness: 2,
                      indent: 30,
                      endIndent: 30,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
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
                              '1',
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
                                "Senate GOP Leader Mitch McConnell has issued a major warning to Democrats: Republicans won't agree to a bill to bolster US competitiveness with CHina if Democrats continue to pursue an economic agenda they are trying to pass along straight party lines this summer",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),

                            //Source hyperlink #1
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "CNN",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
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
                              '2',
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Fact #1
                            Container(
                              margin: EdgeInsets.only(right: 20),
                              child: Text(
                                "A partisan fight erupted over bipartisan legislation aimed at boosting the domestic semiconductor industry on Thursday, as Senate Minority Leader Mitch McConnell threatened Republican support for the bill if Democrats move forward with a separate reconciliation package.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                            //Source hyperlink #1
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(right: 20),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "The Hill",
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
              ),
            ),
            //2
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20),
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 239, 238, 238)),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "https://source.unsplash.com/random/200x200?sig=14")),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Container(
                          child: Text('PMQS'),
                        ),
                        SizedBox(width: 130),
                        Container(
                          child: Text('NAN UNDEFINED, NAN'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Scotland's First Minister Nicola Sturgeon has said she wants a lawful referendum but that the only option is for her party to use it as an election issue.",
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 23),
                          ))),
                  SizedBox(height: 20),
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "-- The UK's Supreme Court will hear arguments in October about whether Scotland can hold a referendum on independence from the United Kingdom--and if it does, Prime Minister Boris Johnson is going to be one of those people. Sturgeon has announced that she plans for her country 'to have its own parliament and government' with powers than Britain as an independent state (like Northern Ireland or Wales), which voted strongly against secession during Brexit...",
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ))),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: ButtonTheme(
                        minWidth: 100,
                        height: 35.0,
                        child: RaisedButton(
                          color: Colors.orange[700],
                          //disabledColor: Colors.orange[700],
                          textColor: Colors.white,
                          //disabledTextColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Read Full Story',
                            style: TextStyle(
                                fontSize: 16.0, // insert your font size here
                                fontWeight: FontWeight.bold),
                          ),

                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Divider(
                      color: Colors.grey,
                      height: 20,
                      thickness: 2,
                      indent: 30,
                      endIndent: 30,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
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
                              '1',
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
                                "Ian Blackfrod has said whoever wins the Tory leadership race, 'Scotland loses' - adding the new PM would 'make Genghis Kahn look like a moderate",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),

                            //Source hyperlink #1
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "BBC",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
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
                              '2',
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Fact #1
                            Container(
                              margin: EdgeInsets.only(right: 20),
                              child: Text(
                                "First Minister Nicola Sturgeon wants to hold a referendum in October next year, and has asked the Supreme Court to rule on whehter she has the power to do so even if the UK government does not grant formal consent.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                            //Source hyperlink #1
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(right: 20),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "BBC",
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
              ),
            ),

            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20),
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 239, 238, 238)),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "https://source.unsplash.com/random/200x200?sig=15")),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Container(
                          child: Text('INDICTMENTS'),
                        ),
                        SizedBox(width: 130),
                        Container(
                          child: Text('23 AUGUST'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Texas school shooting survivor Michael Fanone has called Missouri Attorney General Josh Hawley a "bitch" after footage of the Marjory Stoneman Douglas massacre was released.',
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 23),
                          ))),
                  SizedBox(height: 20),
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "-- Newly released surveillance video from inside the Robb Elementary school in Uvalde, Texas--where a gunman killed 19 children and two teachers on Jan. 6, 2021--is making headlines because of one word: 'brutally violent.' The four-minute footage was presented Thursday to a house committee loing that day's school shooting at Marjory Stoneman Douglas High School; it shows shooter Aaron Hernandez entering his first classroom before opening fire (the Houston Chronicle says he can be seen doing so more than 30 times), reports USA Today). it...",
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ))),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: ButtonTheme(
                        minWidth: 100,
                        height: 35.0,
                        child: RaisedButton(
                          color: Colors.orange[700],
                          //disabledColor: Colors.orange[700],
                          textColor: Colors.white,
                          //disabledTextColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Read Full Story',
                            style: TextStyle(
                                fontSize: 16.0, // insert your font size here
                                fontWeight: FontWeight.bold),
                          ),

                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Divider(
                      color: Colors.grey,
                      height: 20,
                      thickness: 2,
                      indent: 30,
                      endIndent: 30,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
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
                              '1',
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
                                "While it remains unclear exactly what Mr. Holder's footage and testimony might reveal, he interviewed Mr. Trump three times, including once at the former president's Florida residence, Mar-a-Lago, directly after the Jan. 6 attack, according to a person familiar with conversations between the filmmaker and the committee.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),

                            //Source hyperlink #1
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "NY TIMES",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
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
                              '2',
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Fact #1
                            Container(
                              margin: EdgeInsets.only(right: 20),
                              child: Text(
                                "While it remains unclear exactly what Mr. Holder's footage and testimony might reveal, he interviewed Mr. Trump three times, including once at the former president's Florida residence, Mar-a-Lago, directly after the Jan. 6 attack, according to a person familiar with conversations between the filmmaker and the committee.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                            //Source hyperlink #1
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(right: 20),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "NY TIMES",
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
              ),
            ),

            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20),
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 239, 238, 238)),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "https://source.unsplash.com/random/200x200?sig=8")),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Container(
                          child: Text('UKRAINIAN'),
                        ),
                        SizedBox(width: 130),
                        Container(
                          child: Text('21 AUGUST'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Ukraine has begun loading grain on ships bound for Turkish ports, a Ukrainian officail told the BBC.',
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 23),
                          ))),
                  SizedBox(height: 20),
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "-- For the first time since Russia's invasion of Ukraine in February, a ship has left its ports--the AP reports it was loaded with grain on Thrusday and headed for Turkey. The move is 'a significant step' that could help ease global food prices by allowing Ukraine to resume wheat exports after Moscow cut off shipments over concerns about Russian-supplied weapons being used against Ukrainian forces fighting rebels; Reuters describe how things have been dicey at times: than 10 ships carrying around 40 million tons were intially barred form leaving port because...",
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ))),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: ButtonTheme(
                        minWidth: 100,
                        height: 35.0,
                        child: RaisedButton(
                          color: Colors.orange[700],
                          //disabledColor: Colors.orange[700],
                          textColor: Colors.white,
                          //disabledTextColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Read Full Story',
                            style: TextStyle(
                                fontSize: 16.0, // insert your font size here
                                fontWeight: FontWeight.bold),
                          ),

                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Divider(
                      color: Colors.grey,
                      height: 20,
                      thickness: 2,
                      indent: 30,
                      endIndent: 30,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
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
                              '1',
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
                                "The hope is that the exports will help ease the global food crisis while bringing in much neede foreign currency.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),

                            //Source hyperlink #1
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "BBC",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
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
                              '2',
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Fact #1
                            Container(
                              margin: EdgeInsets.only(right: 20),
                              child: Text(
                                "The departure of the Razoni is only a first step, Mr. Blinken said, stressing that Russia must meet its commitments to the deal, which includes facilitating the unimpeded exports of agricultural prodcuts form Black Sea ports.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                            //Source hyperlink #1
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(right: 20),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Washington Times",
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
              ),
            ),

            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20),
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 239, 238, 238)),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "https://source.unsplash.com/random/200x200?sig=5")),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Container(
                          child: Text('PMQS'),
                        ),
                        SizedBox(width: 130),
                        Container(
                          child: Text('NAN UNDEFINED, NAN'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'The Manchin-Schumer infrastructure bill faces a crucial vote in the House on Friday amid fears that moderate Democrats will withhold thier support.',
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 23),
                          ))),
                  SizedBox(height: 20),
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "-- The House is set to vote Friday on a massive 1.1 trillion spending bill that would keep the government running through september--and it's not clear whether Democrats will be among those voting in favor. A number of high-profile holdouts had expressed concerns, including one Democrat who said he was 'troubled' by i... ",
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ))),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: ButtonTheme(
                        minWidth: 100,
                        height: 35.0,
                        child: RaisedButton(
                          color: Colors.orange[700],
                          //disabledColor: Colors.orange[700],
                          textColor: Colors.white,
                          //disabledTextColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Read Full Story',
                            style: TextStyle(
                                fontSize: 16.0, // insert your font size here
                                fontWeight: FontWeight.bold),
                          ),

                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Divider(
                      color: Colors.grey,
                      height: 20,
                      thickness: 2,
                      indent: 30,
                      endIndent: 30,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
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
                              '1',
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
                                "Senate GOP Leader Mitch McConnell has issued a major warning to Democrats: Republicans won't agree to a bill to bolster US competitiveness with CHina if Democrats continue to pursue an economic agenda they are trying to pass along straight party lines this summer",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),

                            //Source hyperlink #1
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "CNN",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
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
                              '2',
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Fact #1
                            Container(
                              margin: EdgeInsets.only(right: 20),
                              child: Text(
                                "A partisan fight erupted over bipartisan legislation aimed at boosting the domestic semiconductor industry on Thursday, as Senate Minority Leader Mitch McConnell threatened Republican support for the bill if Democrats move forward with a separate reconciliation package.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                            //Source hyperlink #1
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(right: 20),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "The Hill",
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
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Text('sdfsdf'),
            )
          ],
        ),
      ),
    );
  }
}
