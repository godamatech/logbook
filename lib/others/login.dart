import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logbook/others/profile.dart';
import 'package:logbook/others/signup.dart';

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

  void _loginWithEmailPassword() async {
    bool isValid = _loginFormKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _loginFormKey.currentState!.save();

    try {
      final userLoginCredentials =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: _enteredEmail, password: _enteredPassword);
      final user = userLoginCredentials.user;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('welcome $_enteredEmail! you have successfully login.')));
        print('welcome $_enteredEmail! you have successfully login.');

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ProfileScreen()));
      }
    } on FirebaseAuthException catch (e) {
      var errorMessage = '';
      if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address';
      } else if (e.code == 'user-disabled') {
        errorMessage =
            'user corresponding to the given email has been disabled';
      } else if (e.code == 'user-not-found') {
        errorMessage =
            'User does not exist, make sure you do your registeration';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'wrong credentials';
      }else {
        errorMessage = e.message.toString();
      }


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('+++++${errorMessage}?? Authentication Failed!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
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
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 7, 43, 105)),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      hintText: 'Email Address',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
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
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      hintText: 'Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 6) {
                        return 'password must be at least 6 characters long!';
                      }
                      return null;
                    },
                    onSaved: (value) => _enteredPassword = value!,
                    obscureText: true,
                  ),
                  SizedBox(height: 16),
                  
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                    },
                    child: Text('Don\'t have an account? Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
