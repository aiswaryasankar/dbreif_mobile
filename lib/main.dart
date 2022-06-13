import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naviation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FirstPage(title: 'Home'),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoggedIn = false;
  Map _userObj = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Codesundar"),
      ),
      body: Container(
        child: _isLoggedIn
            ? Column(
                children: [
                  Image.network(_userObj["picture"]["data"]["url"]),
                  Text(_userObj["name"]),
                  Text(_userObj["email"]),
                  TextButton(
                      onPressed: () {
                        FacebookAuth.instance.logOut().then((value) {
                          setState(() {
                            _isLoggedIn = false;
                            _userObj = {};
                          });
                        });
                      },
                      child: Text("Logout"))
                ],
              )
            : Center(
                child: ElevatedButton(
                  child: Text("Login with Facebook"),
                  onPressed: () async {
                    FacebookAuth.instance.login(
                        permissions: ["public_profile", "email"]).then((value) {
                      FacebookAuth.instance.getUserData().then((userData) {
                        setState(() {
                          _isLoggedIn = true;
                          _userObj = userData;
                        });
                      });
                    });
                  },
                ),
              ),
      ),
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(left: 40, right: 40),
                child: Image.network(
                    'https://lh3.googleusercontent.com/BBpGGMxXErenT0wD1RZCsmsUw5mfOeDDK4fhn0xOtc8wY37OusniLsbkakBa2SH2zrRKUg=s170')),
            SizedBox(height: 22),
            Container(
                margin: EdgeInsets.only(left: 40, right: 40),
                child: Image.network(
                  'https://lh3.googleusercontent.com/sOGjXaEJT7FgLzjit30Vjc8njU8jxI6_E-09kb5fXMm7gXvdcy3t-79_4Eb4nepXHu_JUq4=s136',
                  scale: .6,
                )),
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
            SizedBox(height: 4),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: ButtonTheme(
                minWidth: 270,
                height: 47.0,
                child: RaisedButton(
                  color: Colors.blue[700],
                  //disabledColor: Colors.orange[700],
                  textColor: Colors.white,
                  //disabledTextColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    'Go to Facebook',
                    style: TextStyle(
                        fontSize: 16.0, // insert your font size here
                        fontWeight: FontWeight.bold),
                  ),

                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
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
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ThirdPage(title: 'Sign In Page')));
                  },
                ),
              ),
            ),
            //fix size
            SizedBox(height: 10),
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
                margin: EdgeInsets.only(left: 60, right: 10),
                child: Image.network(
                    'https://lh3.googleusercontent.com/BBpGGMxXErenT0wD1RZCsmsUw5mfOeDDK4fhn0xOtc8wY37OusniLsbkakBa2SH2zrRKUg=s170')),
            Container(
              width: 278,
              margin: EdgeInsets.only(left: 50, top: 10),
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
                    margin: EdgeInsets.only(left: 60, right: 10),
                    child: Image.network(
                        'https://lh3.googleusercontent.com/BBpGGMxXErenT0wD1RZCsmsUw5mfOeDDK4fhn0xOtc8wY37OusniLsbkakBa2SH2zrRKUg=s170')),
                Container(
                    width: 278,
                    margin: EdgeInsets.only(left: 50, top: 10),
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
                      SizedBox(height: 15),
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
