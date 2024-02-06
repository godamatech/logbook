import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logbook/others/profile.dart';

final _firebaseAuth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  String _enteredEmail = '';
  String _enteredPassword = '';

  void _loginWithEmailPassword() {
    bool isValid = _loginFormKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _loginFormKey.currentState!.save();

    try {
      final userLoginCredentials = _firebaseAuth.signInWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('welcome $_enteredEmail! you have successfully login.')));
      print('welcome $_enteredEmail! you have successfully login.');

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ProfileScreen()));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('+++++${e.message}?? Authentication Failed!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    print('\n......from Login Page .......\n');
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _loginFormKey,
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
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value!.length < 6) {
                      return 'Password must be atleast 6 characters long!';
                    }
                    return null;
                  },
                  onSaved: (value) => _enteredPassword = value!,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Implement login logic
                    _loginWithEmailPassword();
                  },
                  child: Text('Login'),
                ),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    // Navigate to Sign-Up Page
                    Navigator.pop(context);
                  },
                  child: Text('Don\'t have an account? Sign Up'),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
