import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logbook/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:logbook/others/login.dart';
import 'package:logbook/others/signup.dart';
import 'package:logbook/screens/profile.dart';
import 'package:logbook/screens/splash.dart';
import 'package:logbook/others/start.dart';
import 'package:logbook/screens/auth.dart';
import 'package:logbook/others/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laboratory Logbook',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 7, 43, 105)),
      ),
      // home: LogScreen(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if (snapshot.hasData) {
            return const ProfileScreen();
          }

          // return const AuthScreen();
          return const LogScreen();
        },
      ),
    );
  }
}
