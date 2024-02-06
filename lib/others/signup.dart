import 'package:flutter/material.dart';
import 'package:logbook/others/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

var _firebaseAuth = FirebaseAuth.instance;

class SignUpPage extends StatelessWidget {
  final _signupFormKey = GlobalKey<FormState>();
  String _enteredEmail = '';
  String _enteredPassword = '';

  void _signupWithEmailPassword() {
    bool isValid = _signupFormKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _signupFormKey.currentState!.save();

    try {
      final userLoginCredentials = _firebaseAuth.createUserWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text(
      //         'welcome $_enteredEmail! your Registration was successful.')));
      print('welcome $_enteredEmail! you have successfully Registered.');
    } on FirebaseAuthException catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text('+++++${e.message}?? Authentication Failed!')));
      print('+++++${e.message}?? Authentication Failed!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _signupFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                autocorrect: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Enter a valid email address!';
                  }
                  return null;
                },
                onSaved: (value) => _enteredEmail = value!,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                autocorrect: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.trim().length < 6) {
                    return 'password must be at least 6 characters long!';
                  }
                  return null;
                },
                onSaved: (value) => _enteredPassword = value!,
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Implement sign-up logic
                  _signupWithEmailPassword();
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  // Navigate to Login Page
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text('Already have an account? Login'),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
