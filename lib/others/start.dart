import 'package:flutter/material.dart';
import 'package:logbook/others/home.dart';
import 'package:logbook/others/signup.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});
  @override
  State<LogScreen> createState() {
    return _LogScreenState();
  }
}

class _LogScreenState extends State<LogScreen> {
  var activeScreeen = 'home-screen';

  void switchScreen() {
    setState(() {
      activeScreeen = 'signup-screen';
    });
  }

  Widget? screenWidget;
  @override
  Widget build(context) {
    if (activeScreeen == 'start-screen' || activeScreeen == 'home-screen') {
      screenWidget = HomePage();
    } else if (activeScreeen == 'signup-screen') {
      screenWidget = SignUpPage();
    } else {}

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // colors: [Colors.deepPurple, Colors.purple],
              // begin: Alignment.topCenter,
              // end: Alignment.bottomCenter,
              colors: [Colors.blue.shade700, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: screenWidget,
          ),
        ),
      ),
    );
  }
}
