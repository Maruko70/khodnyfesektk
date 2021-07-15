import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:khodnyfesektk/Screens/CompleteRegisterScreen.dart';
import 'package:khodnyfesektk/Screens/Contactus.dart';
import 'package:khodnyfesektk/Screens/HomeScreen.dart';
import 'package:khodnyfesektk/Screens/Profile.dart';
import 'package:khodnyfesektk/Screens/TopRatings.dart';
import 'package:provider/provider.dart';
import 'Screens/AddRide.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/RegisterScreen.dart';
import 'Services/shared.dart';
import 'ad_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  await Firebase.initializeApp();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  runApp(Provider.value(
    value: adState,
    builder: (context, child) => MyApp(),
  ));
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
      initialRoute: sharedPrefs.loggedin ? sharedPrefs.gender.length > 3 ? "/home" : "/completerreg" : "/login",
      routes: {
        "/home": (_) => HomeScreen(),
        "/profile": (BuildContext context) => ProfileScreen(),
        "/completerreg": (BuildContext context) => CompleteRegister(),
        "/register": (BuildContext context) => RegisterScreen(),
        "/login": (BuildContext context) => LoginScreen(),
        "/add": (BuildContext context) => AddRideScreen(),
        "/contact": (BuildContext context) => ContactUs(),
        "/ratings": (BuildContext context) => TopRatings(),
      },
    );
  }
}

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var loggedin = sharedPrefs.loggedin;

    if (loggedin) {
      if(FirebaseAuth.instance.currentUser != null){
        if(sharedPrefs.gender.isEmpty || sharedPrefs.phone.isEmpty)
        return CompleteRegister();
        else
        return HomeScreen();
      }
      else{
      return LoginScreen();
      }
    }
    else{
    return LoginScreen();
    }
  }
}
