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
      home: const FirstPage(title: 'FirstPage'),
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          RaisedButton(
            child: Text('SecondPage'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SecondPage(title: 'SecondPage')));
            },
          ),
          RaisedButton(
            child: Text('ThirdPage'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ThirdPage(title: 'ThirdPage')));
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
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ThirdPage(title: 'ThirdPage')));
          },
          child: const Text('ThirdPage'),
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
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const SecondPage(title: 'SecondPage')));
          },
          child: const Text('Second Page'),
        ),
      ),
    );
  }
}
