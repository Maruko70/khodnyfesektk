import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khodnyfesektk/Screens/CompleteRegisterScreen.dart';
import 'package:khodnyfesektk/Screens/Profile.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/RegisterScreen.dart';
import 'Services/shared.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khodny Fe Sektk',
      theme: ThemeData(
        fontFamily: GoogleFonts.tajawal().fontFamily,
        primarySwatch: Colors.yellow,
      ),
      home: Authenticate(),
    );
  }
}

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var loggedin = sharedPrefs.loggedin;

    if (loggedin) {
      if(sharedPrefs.gender == "" || sharedPrefs.phone == "")
      return CompleteRegister();
      else
      return ProfileScreen();
    }
    else{
    return LoginScreen();
    }
  }
}
