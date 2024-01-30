import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome User'),
      ),
      body: const Center(
        child: Text('Welcome to the Lab Logbook!'),
      ),
    );
  }
}
