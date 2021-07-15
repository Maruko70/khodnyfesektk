import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khodnyfesektk/Screens/Navbar.dart';
import 'package:khodnyfesektk/Screens/RidesHistory.dart';
import 'package:khodnyfesektk/Services/auth.dart';
import 'package:khodnyfesektk/Services/shared.dart';
import 'package:khodnyfesektk/consts.dart';
import 'package:provider/provider.dart';

import '../ad_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({ Key? key }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  BannerAd? banner;
  File? _imageFile;
  final picker =  ImagePicker();
  bool _load = false;
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future pickImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
    uploadImage();
  }

  Future uploadImage() async{
    String rnd = getRandomString(5);
    String fileName = "${sharedPrefs.uid}-${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-$rnd";
    FirebaseStorage.instance.ref().child('uploads/$fileName').putFile(_imageFile!).then((val) async {
      var link = await val.ref.getDownloadURL();
      setState(() {
        FirebaseFirestore.instance.collection('Users').doc(sharedPrefs.uid).update({"pp" : link}).whenComplete((){
          setState(() {
            sharedPrefs.pp = link;
          });
        });
      });
    });    
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initilization.then((status){
      setState(() {
        banner = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.banner,
          request: AdRequest(),
          listener: adState.adListener,
        )..load();
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Directionality(textDirection: TextDirection.rtl,
      child: Scaffold(
        bottomNavigationBar: Navbar(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("الملف الشخصي", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          width: size.width,
          height: size.height,
          color: Colors.yellow,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: sharedPrefs.pp.isEmpty ? Image.network("https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg", width: 100) : Image.network(sharedPrefs.pp, width: 100, height: 100),
                    ),
                  ),
                  CircleAvatar(child: IconButton(onPressed: pickImage, icon: Icon(Icons.camera_alt))),
                ],
              ),
              SizedBox(height: 10.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(sharedPrefs.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
                  SizedBox(width: 10,),
                  sharedPrefs.gender == "male" ? Icon(Icons.male) : sharedPrefs.gender == "female" ? Icon(Icons.female) : Text(""),
                ],
              ),
              Text(sharedPrefs.email, style: TextStyle(fontSize: 16,),),
              SizedBox(height: 30.0,),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RidesHistory()));
                },
                child: Container(
                  width: size.width - 40,
                  height: 45.0,
                  decoration: kBoxDecorationStyle2,
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text("تاريخ الرحلات", style: TextStyle(fontSize: 18),),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacementNamed(context, "/contact");
                },
                child: Container(
                  width: size.width - 40,
                  height: 45.0,
                  decoration: kBoxDecorationStyle2,
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text("تواصل معنا", style: TextStyle(fontSize: 18),),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacementNamed(context, "/ratings");
                },
                child: Container(
                  width: size.width - 40,
                  height: 45.0,
                  decoration: kBoxDecorationStyle2,
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text("التقييمات", style: TextStyle(fontSize: 18),),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              ),
              /*SizedBox(height: 10.0,),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacementNamed(context, "/contact");
                },
                child: Container(
                  width: size.width - 40,
                  height: 45.0,
                  decoration: kBoxDecorationStyle2,
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text("الطلبات", style: TextStyle(fontSize: 18),),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacementNamed(context, "/contact");
                },
                child: Container(
                  width: size.width - 40,
                  height: 45.0,
                  decoration: kBoxDecorationStyle2,
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text("تواصل معنا", style: TextStyle(fontSize: 18),),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              ),*/
              SizedBox(height: 10.0,),
              GestureDetector(
                onTap: (){
                  AuthService().logOut(context);
                },
                child: Container(
                  width: size.width - 40,
                  height: 45.0,
                  decoration: kBoxDecorationStyle2,
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text("تسجيل خروج", style: TextStyle(fontSize: 18),),
                        Spacer(),
                        Icon(Icons.logout),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60),
              Container(
                height: 50,
                child: AdWidget(ad: banner!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}