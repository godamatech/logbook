import 'package:flutter/material.dart';
import 'package:logbook/others/signup.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome to Lab Logbook!',
                style: TextStyle(color: Colors.blue.shade100, fontSize: 24.0),
              ),
              SizedBox(height: 30),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue[100],
                ),
                label: Text('Let\'s begin'),
                icon: Icon(Icons.arrow_right_alt),
              )
            ],
          ),
        ),
      ),
    );
    // Scaffold(
    // appBar: AppBar(
    //   backgroundColor: Colors.blue.shade400,
    //   title: Text(
    //     'Lab Logbook',
    //     style: TextStyle(color: Colors.blue.shade900),
    //   ),
    // ),
    // Container(
    //   decoration: BoxDecoration(
    //     gradient: LinearGradient(
    //       ),
    //   ),begin: Alignment.topCenter,
    //       end: Alignment.bottomCenter,
    //       colors: [Colors.blue.shade700, Colors.blue.shade400],
    //
    //   child: ,
    // ),
    // );
  }
}
