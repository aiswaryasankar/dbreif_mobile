import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleSignInAccount? _currentUser;
  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Google Sign in'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: _buildWidget(),
      ),
    );
  }

  Widget _buildWidget() {
    GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ListTile(
              leading: GoogleUserCircleAvatar(identity: user),
              title: Text(user.displayName ?? ''),
              subtitle: Text(user.email),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Signed in successfully',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: signOut, child: const Text('Sign Out'))
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'You are not signed in',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: signIn, child: Text('Sign In')),
          ],
        ),
      );
    }
  }

  void signOut() {
    _googleSignIn.disconnect();
  }

  Future<void> signIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (e) {
      print("Error signing in $e");
    }
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
                    'https://lh3.googleusercontent.com/v03VG2x0dRabjFJcBy3igJKX1g4Nl81OcRqL-6OSFtrpK6VVcVIeEzmKU-NXriVEsDa6PUo=s170')),
            SizedBox(height: 22),
            Container(
                margin: EdgeInsets.only(left: 40, right: 40),
                child: Image.network(
                  'https://lh3.googleusercontent.com/-QsiSeFhufaqug88GU48epFPaQNq95ARnS-AE2Iq692SUAt5Sx9uYeQWwScW_-rmLAjM=s144',
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
                    'https://lh3.googleusercontent.com/v03VG2x0dRabjFJcBy3igJKX1g4Nl81OcRqL-6OSFtrpK6VVcVIeEzmKU-NXriVEsDa6PUo=s170')),
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
                        'https://lh3.googleusercontent.com/v03VG2x0dRabjFJcBy3igJKX1g4Nl81OcRqL-6OSFtrpK6VVcVIeEzmKU-NXriVEsDa6PUo=s170')),
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
