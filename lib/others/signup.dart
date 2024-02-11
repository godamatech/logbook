import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:logbook/others/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logbook/widgets/user_image_picker.dart';

var _firebaseAuth = FirebaseAuth.instance;

class SignUpPage extends StatelessWidget {
  final _signupFormKey = GlobalKey<FormState>();

  String _enteredEmail = '';
  String _enteredPhone = '';
  String _enteredPassword = '';
  String _enteredConfirmPassword = '';
  // String _enteredRegNo = '';
  String _enteredOtherNames = '';
  String _enteredSurname = '';
  String _enteredUserType = '';
  String _enteredGender = '';

  File? _selectedImage;
  bool _isAuthenticating = true;

  void _signupWithEmailPassword() async {
    bool isValid = _signupFormKey.currentState!.validate();

    if (!isValid || _selectedImage == null) {
      return;
    }

    _signupFormKey.currentState!.save();

    try {
      final userSignupCredentials =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );
      final user = userSignupCredentials.user;
      if (user != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userSignupCredentials.user!.uid}.jpg');
        storageRef.putFile(_selectedImage!);
        final _imageUrl = await storageRef.getDownloadURL();

        print(_imageUrl);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userSignupCredentials.user!.uid)
            .set({
          'surname': _enteredSurname,
          // 'other_names': _enteredOtherNames,
          'email': _enteredEmail,
          'phone': _enteredPhone,
          // 'gender': _enteredGender,
          // 'user_type': _enteredUserType,
          // 'image_url': _imageUrl,
        });
        //    welcome $_enteredEmail! your Registration was successful.')));
        print('welcome $_enteredEmail! you have successfully Registered.');
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
      } else {
        errorMessage = e.message.toString();
      }

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text('+++++${e.message}?? Authentication Failed!')));
      print('+++++${errorMessage}?? Authentication Failed!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: SingleChildScrollView(
            child: Form(
              key: _signupFormKey,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UserImagePicker(
                      onPickImage: (pickedImage) =>
                          _selectedImage = pickedImage,
                    ),
                    SingleChildScrollView(
                      child: Column(children: [
                        TextFormField(
                          autocorrect: true,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 7, 43, 105)),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            hintText: 'Surname',
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().length < 3) {
                              return 'Name can not be less than 3 characters!';
                            }
                            return null;
                          },
                          onSaved: (value) => _enteredSurname = value!,
                        ),
                        // SizedBox(height: 16.0),
                        // TextFormField(
                        //   autocorrect: true,
                        //   decoration: InputDecoration(
                        //     enabledBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(color: Colors.deepPurple),
                        //       borderRadius: BorderRadius.circular(22),
                        //     ),
                        //     hintText: 'Other Names',
                        //     fillColor: Colors.grey[200],
                        //     filled: true,
                        //   ),
                        //   validator: (value) {
                        //     if (value == null || value.trim().length < 3) {
                        //       return 'Name can not be less than 3 characters!';
                        //     }
                        //     return null;
                        //   },
                        //   onSaved: (value) => _enteredOtherNames = value!,
                        // ),
                        // SizedBox(height: 16.0),
                        TextFormField(
                          autocorrect: true,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.deepPurple),
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
                        // SizedBox(height: 16.0),
                        TextFormField(
                          autocorrect: true,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.deepPurple),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            hintText: 'Phone Number',
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().length < 10) {
                              return 'Phone Number must be 11 digits!';
                            }
                            return null;
                          },
                          onSaved: (value) => _enteredPhone = value!,
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
                        SizedBox(height: 16.0),
                        // TextFormField(
                        //   autocorrect: true,
                        //   decoration: InputDecoration(
                        //     enabledBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(color: Colors.deepPurple),
                        //       borderRadius: BorderRadius.circular(22),
                        //     ),
                        //     hintText: 'Confirm Password',
                        //     fillColor: Colors.grey[200],
                        //     filled: true,
                        //   ),
                        //   validator: (value) {
                        //     if (value == null || value.trim().length < 6) {
                        //       return 'password must be at least 6 characters long!';
                        //     }
                        //     return null;
                        //   },
                        //   onSaved: (value) => _enteredConfirmPassword = value!,
                        //   obscureText: true,
                        // ),
                        // SizedBox(height: 16),
                        // TextFormField(
                        //   autocorrect: true,
                        //   decoration: InputDecoration(
                        //     enabledBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(color: Colors.deepPurple),
                        //       borderRadius: BorderRadius.circular(22),
                        //     ),
                        //     hintText: 'Enter Male/Female',
                        //     fillColor: Colors.grey[200],
                        //     filled: true,
                        //   ),
                        //   validator: (value) {
                        //     if (value == null || value.trim().length < 4) {
                        //       return 'Enter Male/Female';
                        //     }
                        //     return null;
                        //   },
                        //   onSaved: (value) => _enteredGender = value!,
                        // ),
                        SizedBox(height: 16),
                        // TextFormField(
                        //   autocorrect: true,
                        //   decoration: InputDecoration(
                        //     enabledBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(color: Colors.deepPurple),
                        //       borderRadius: BorderRadius.circular(22),
                        //     ),
                        //     hintText: 'Select Student/Lecturer',
                        //     fillColor: Colors.grey[200],
                        //     filled: true,
                        //   ),
                        //   validator: (value) {
                        //     if (value == null || value.trim().length < 4) {
                        //       return 'Student/Lecturer';
                        //     }
                        //     return null;
                        //   },
                        //   onSaved: (value) => _enteredUserType = value!,
                        // ),
                      ]),
                    ),

                    SizedBox(height: 16.0),
                    // if (_isAuthenticating) CircularProgressIndicator(),
                    // if (!_isAuthenticating)
                    //   (
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
                    // ),
                    SizedBox(height: 16.0),
                    // if (!_isAuthenticating)
                    //   (
                    TextButton(
                      onPressed: () {
                        // Navigate to Login Page
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Text('Already have an account? Login'),
                    ),
                    // ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
