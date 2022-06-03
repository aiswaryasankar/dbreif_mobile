import 'package:flutter/material.dart';

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
            RaisedButton(
              child: Text('Get Started'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SecondPage(title: 'Sign Up Page')));
              },
            ),
            RaisedButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ThirdPage(title: 'Sign In Page')));
              },
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
              width: 500,
              margin: EdgeInsets.only(left: 300, top: 10),
              decoration: new BoxDecoration(color: Colors.grey),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: "Full Name"),
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Email"),
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Password"),
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Confirm Password"),
                  ),
                  ButtonTheme(
                    minWidth: 270,
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
                    width: 500,
                    margin: EdgeInsets.only(left: 380, top: 10),
                    decoration: new BoxDecoration(color: Colors.grey),
                    child: Column(children: [
                      TextField(
                          decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Email",
                      )),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Password",
                        ),
                      ),
                      ButtonTheme(
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
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SecondPage(title: 'Sign Up Page')));
                        },
                        child: const Text("Don't have an account?"),
                      ),
                    ]))
              ]),
        ));
  }
}
