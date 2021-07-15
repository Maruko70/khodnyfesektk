import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khodnyfesektk/Screens/LoginScreen.dart';
import 'package:khodnyfesektk/Screens/RegisterScreen.dart';
import 'package:khodnyfesektk/Services/shared.dart';

class AuthService {

  Future<UserCredential?> signInWithFacebook() async {
      final LoginResult result = await FacebookAuth.instance.login(permissions: ['public_profile', 'email']);
      if(result.status == LoginStatus.success){
        // Create a credential from the access token
        final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
        // Once signed in, return the UserCredential
        final userData = await FacebookAuth.instance
          .getUserData(fields: "email,name,picture.width(200),gender");
        UserCredential? userr = await FirebaseAuth.instance.signInWithCredential(credential).then((user) async {
          if(!user.additionalUserInfo!.isNewUser){
          var data = await FirebaseFirestore.instance.collection('Users').doc(user.user!.uid).get();
          sharedPrefs.gender = data['gender'];
          sharedPrefs.smoker = data['smoker'];
          sharedPrefs.phone = data['phone'];
          sharedPrefs.driver = data['driver'];
          FirebaseFirestore.instance.collection('User').doc(user.user!.uid).set({
            "uid" : user.user!.uid,
            "name" : data['name'],
            "email" : data['email'],
          });
        }
        sharedPrefs.loggedin = true;
        sharedPrefs.uid = user.user!.uid;
        sharedPrefs.email = userData['email'];
        sharedPrefs.name = userData['name'];
        sharedPrefs.pp = userData['picture']['data']['url'];
        return user;
        });
        return userr;
      }
  }

  Future<UserCredential?> signInWithGoogle() async{
    GoogleSignInAccount? googleUser = await GoogleSignIn.standard().signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    UserCredential? user = await FirebaseAuth.instance.signInWithCredential(credential).then((user) async {
      if(!user.additionalUserInfo!.isNewUser){
          var data = await FirebaseFirestore.instance.collection('Users').doc(user.user!.uid).get();
          sharedPrefs.gender = data['gender'];
          sharedPrefs.smoker = data['smoker'];
          sharedPrefs.phone = data['phone'];
          sharedPrefs.driver = data['driver'];
        }
        sharedPrefs.loggedin = true;
        sharedPrefs.uid = user.user!.uid;
        sharedPrefs.email = googleUser.email;
        sharedPrefs.name = googleUser.displayName!;
        sharedPrefs.pp = googleUser.photoUrl!;
    });
    return user;
  }

  Future<void> logOut(context) async {
    await FacebookAuth.instance.logOut();
    sharedPrefs.clearShared();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<UserCredential?> reigester(String email, String password, String name) async{
    try{
      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);    
      sharedPrefs.uid = result.user!.uid;
        CollectionReference users = FirebaseFirestore.instance.collection("Users");
        users.doc(result.user!.uid).set({
          "uid" : result.user!.uid,
          "name" : name,
          "email" : email,
        });   
      return result; 
    } catch (e){
      print(e.toString());
      return null;
    }
  }

  Future<UserCredential?> signIn(String email, String password) async{
    try{
      final UserCredential? firebaseUser = (await FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: email,
        password: password
    ).catchError((errMsg){
      print("Error: " + errMsg.toString());
    }));

    if(firebaseUser != null)
    {
      var uff = await FirebaseFirestore.instance.collection('Users').doc(firebaseUser.user!.uid).get();
      var uffd = uff.data();
      sharedPrefs.name = uffd!['name'];
      sharedPrefs.email = uffd['email'];
      sharedPrefs.uid = firebaseUser.user!.uid;
      sharedPrefs.gender = uffd['gender'];
      sharedPrefs.phone = uffd['phone'];
      sharedPrefs.smoker = uffd['smoker'];
      sharedPrefs.pp = uffd['pp'];
      sharedPrefs.driver = uffd['driver'];
      sharedPrefs.loggedin = true;
    }
    return firebaseUser;
    }catch(e){
      print(e.toString());
      return null;
    }
  }



  String validateName(String value) {
    if (value.length < 3)
      return 'الاسم يجب ان يكون اكثر من حرفين';
    else
      return '';
  }

  String validateAddress(String value) {
    if (value.length < 9)
      return 'العنوان يجب ان اكثر من 10 حروف';
    else
      return '';
  }

  String validateMobile(String value) {
    if (value.length != 10)
      return 'رقم الهاتف يجب ان يكون من 10 ارقام';
    else
      return '';
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'ادخل بريد الكتروني صالح';
    else
      return '';
  }
}
