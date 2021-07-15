import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:khodnyfesektk/Screens/LoginScreen.dart';
import 'package:khodnyfesektk/Services/auth.dart';
import 'package:khodnyfesektk/Services/shared.dart';
import 'package:khodnyfesektk/ad_state.dart';
import 'package:provider/provider.dart';

import '../consts.dart';
import 'CompleteRegisterScreen.dart';
import 'HomeScreen.dart';
import 'Profile.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String state = "type";
  final TextEditingController _nameTextEditingConroller = TextEditingController();
  final TextEditingController _emailTextEditingConroller = TextEditingController();
  final TextEditingController _passwordTextEditingConroller = TextEditingController();

  bool _load = false;

  BannerAd? banner;

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
    if (state == "type") {
      return Scaffold(
        appBar: AppBar(
          leading: TextButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          }, child: Text("رجوع", style: TextStyle(fontSize: 18, color: Colors.white, decorationStyle: TextDecorationStyle.wavy, decoration: TextDecoration.underline),),),
              elevation: 0,
        ),
        body: Container(
          color: Colors.yellow,
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 150),
              Container(margin: EdgeInsets.only(right: 30), child: Text("اختار نوع التسجيل", style: TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold,), textAlign: TextAlign.right)),
              SizedBox(height : 60.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 65,
                    decoration: kBoxDecorationStyle2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              state = "driver";
                            });
                          },
                          icon: Icon(Icons.drive_eta),
                        ),
                        Text("سائق"),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 150,
                    height: 65,
                    decoration: kBoxDecorationStyle2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              state = "client";
                            });
                          },
                          icon: Icon(Icons.person),
                        ),
                        Text("عميل")
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 150),
              Container(
                height: 50,
                child: AdWidget(ad: banner!),
              ),
            ],
          ),
        ),
      );
    } else if(state == "driver") {
      return Scaffold(
        appBar: AppBar(
          leading: TextButton(onPressed: (){setState(() {
                state = "type";
              });}, child: Text("رجوع", style: TextStyle(fontSize: 18, color: Colors.white, decorationStyle: TextDecorationStyle.wavy, decoration: TextDecoration.underline),),),
              elevation: 0,
        ),
        body:Directionality(textDirection: TextDirection.rtl, 
        child: Stack(
          children: [
            Container(
              color: Colors.yellow,
              height: size.height,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 60.0),
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                      onTap: () {
                        setState(() {
                          _load = true;
                        });
                        AuthService().signInWithFacebook().then((value){
                          if(value!.additionalUserInfo!.isNewUser || sharedPrefs.gender.length < 4)
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompleteRegister(driver: true)));
                          else
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                        }).whenComplete((){
                          setState(() {
                            _load = false;
                          });
                        });
                      },
                      child: Container(
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.facebook,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "الدخول باستخدام فيسبوك",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )),
                        height: 50,
                        width: 250,
                        decoration: kBoxDecorationStyle2,
                      ),
                    ),
                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _load = true;
                        });
                        AuthService().signInWithGoogle().then((value){
                          if(value!.additionalUserInfo!.isNewUser || sharedPrefs.gender.length < 4)
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompleteRegister(driver: true)));
                          else
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                        }).whenComplete((){
                          setState(() {
                            _load = true;
                          });
                        });
                      },
                      child: Container(
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network("https://cdn.earthtoday.com/Lu9vcjaQdBUXGesIgc0AxIbO0To=/840x0/https%3A%2F%2Fwww.google.com%2Fimages%2Fbranding%2Fgoogleg%2F1x%2Fgoogleg_standard_color_128dp.png", width: 25),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "الدخول باستخدام جوجل",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )),
                        height: 50,
                        width: 250,
                        decoration: kBoxDecorationStyle2,
                      ),
                    ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              decoration: kBoxDecorationStyle2,
                              height: 60.0,
                                child: TextFormField(
                                  controller: _nameTextEditingConroller,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                  color: Colors.black, 
                                ),
                              decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.person, color: Colors.black,),
                              hintText: "ادخل اسمك الكامل",
                              hintStyle: kHintTextStyle,
                              contentPadding: EdgeInsets.only(top: 15),
                              ),
                            ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              decoration: kBoxDecorationStyle2,
                              height: 60.0,
                                child: TextFormField(
                                  controller: _emailTextEditingConroller,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                  color: Colors.black, 
                                ),
                              decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.email, color: Colors.black,),
                              hintText: "ادحل بريدك الالكتروني",
                              hintStyle: kHintTextStyle,
                              contentPadding: EdgeInsets.only(top: 15),
                              ),
                            ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              decoration: kBoxDecorationStyle2,
                              height: 60.0,
                                child: TextFormField(
                                  controller: _passwordTextEditingConroller,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                  color: Colors.black, 
                                ),
                              obscureText: true,
                              decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.password, color: Colors.black,),
                              hintText: "ادخل كلمة المرور",
                              hintStyle: kHintTextStyle,
                              contentPadding: EdgeInsets.only(top: 15),
                              ),
                            ),
                            ),
                          ),
                          Container(
                        height: 60,
                        decoration: kBoxDecorationStyle2.copyWith(borderRadius: BorderRadius.circular(50)),
                        width: size.width - 40,
                        child: ElevatedButton(onPressed: (){
                          setState(() {
                            _load = true;
                          });
                          if(_nameTextEditingConroller.text.isEmpty || _nameTextEditingConroller.text.length < 3)
                          Fluttertoast.showToast(msg: "الاسم لا يمكن ان يكون فارغاً ويجب ان يحتوي على 3 احرف على الاقل");
                          else if(_emailTextEditingConroller.text.isEmpty || _emailTextEditingConroller.text.length < 5)
                          Fluttertoast.showToast(msg: "يجب ادخال بريد الكتروني صحيح");
                          else if(_passwordTextEditingConroller.text.isEmpty || _passwordTextEditingConroller.text.length < 7)
                          Fluttertoast.showToast(msg: "كلمة المرور يجب ان تتكون من 7 احرف على الاقل");
                          else{
                            AuthService().reigester(_emailTextEditingConroller.text.trim(), _passwordTextEditingConroller.text.trim(), _nameTextEditingConroller.text.trim()).then((va) async {
                              FirebaseFirestore.instance.collection('Users').doc(va!.user!.uid).set({
                                "uid" : va.user!.uid,
                                "name" : _nameTextEditingConroller.text.trim(),
                                "email" : _emailTextEditingConroller.text.trim(),
                              });
                              var uu = await FirebaseFirestore.instance.collection('Users').doc(va.user!.uid).get();
                              sharedPrefs.uid = uu['uid'];
                              sharedPrefs.loggedin = true;
                              FirebaseFirestore.instance.collection('Users').doc(va.user!.uid).update({"cride" : ""});                             
                            }).whenComplete((){
                              sharedPrefs.name = _nameTextEditingConroller.text.trim();
                              sharedPrefs.email = _emailTextEditingConroller.text.trim();
                              sharedPrefs.driver = true;                       
                              setState(() {
                                _load = false;
                              });
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompleteRegister(driver: true))); 
                            });
                          }
                        }, child: Text("تسجيل"), style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      textStyle: TextStyle(
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                      ),),
                     ),
                     SizedBox(height: 30.0,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text("لديك حساب؟", style: TextStyle(fontSize: 18),),
                         SizedBox(width: 5.0),
                         GestureDetector(
                           child: Text("دخول", style: TextStyle(fontSize: 20, decoration: TextDecoration.underline,),),
                           onTap: (){
                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                           },
                         ),
                       ],
                     ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    child: AdWidget(ad: banner!),
                  ),
                ],
              ),
            ),
            if(_load)
            Container(
              color: Colors.black.withOpacity(0.50),
              child: Center(child: CircularProgressIndicator(),),
            ),
          ],
        ),
        ),
      );
    }
    else if (state == "client") {
      return Scaffold(
        appBar: AppBar(
          leading: TextButton(onPressed: (){setState(() {
                state = "type";
              });}, child: Text("رجوع", style: TextStyle(fontSize: 18, color: Colors.white, decorationStyle: TextDecorationStyle.wavy, decoration: TextDecoration.underline),),),
              elevation: 0,
        ),
        body:Directionality(textDirection: TextDirection.rtl, 
        child: Stack(
          children: [
            Container(
              color: Colors.yellow,
              height: size.height,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 60.0),
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                      onTap: () {
                        setState(() {
                          _load = true;
                        });
                        AuthService().signInWithFacebook().then((value){
                          setState(() {
                            _load = true;
                          });
                          if(value!.additionalUserInfo!.isNewUser || sharedPrefs.gender.length < 4)
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompleteRegister()));
                          else
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                        }).whenComplete((){
                          setState(() {
                            _load = true;
                          });
                        });
                      },
                      child: Container(
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.facebook,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "الدخول باستخدام فيسبوك",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )),
                        height: 50,
                        width: 250,
                        decoration: kBoxDecorationStyle2,
                      ),
                    ),
                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap: () {
                        AuthService().signInWithGoogle().then((value){
                          setState(() {
                            _load = true;
                          });
                          if(value!.additionalUserInfo!.isNewUser || sharedPrefs.gender.length < 4)
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompleteRegister()));
                          else
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                        }).whenComplete((){
                          setState(() {
                            _load = true;
                          });
                        });
                      },
                      child: Container(
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network("https://cdn.earthtoday.com/Lu9vcjaQdBUXGesIgc0AxIbO0To=/840x0/https%3A%2F%2Fwww.google.com%2Fimages%2Fbranding%2Fgoogleg%2F1x%2Fgoogleg_standard_color_128dp.png", width: 25),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "الدخول باستخدام جوجل",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )),
                        height: 50,
                        width: 250,
                        decoration: kBoxDecorationStyle2,
                      ),
                    ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              decoration: kBoxDecorationStyle2,
                              height: 60.0,
                                child: TextFormField(
                                  controller: _nameTextEditingConroller,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                  color: Colors.black, 
                                ),
                              decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.person, color: Colors.black,),
                              hintText: "ادخل اسمك الكامل",
                              hintStyle: kHintTextStyle,
                              contentPadding: EdgeInsets.only(top: 15),
                              ),
                            ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              decoration: kBoxDecorationStyle2,
                              height: 60.0,
                                child: TextFormField(
                                  controller: _emailTextEditingConroller,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                  color: Colors.black, 
                                ),
                              decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.email, color: Colors.black,),
                              hintText: "ادحل بريدك الالكتروني",
                              hintStyle: kHintTextStyle,
                              contentPadding: EdgeInsets.only(top: 15),
                              ),
                            ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              decoration: kBoxDecorationStyle2,
                              height: 60.0,
                                child: TextFormField(
                                  controller: _passwordTextEditingConroller,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                  color: Colors.black, 
                                ),
                              obscureText: true,
                              decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.password, color: Colors.black,),
                              hintText: "ادخل كلمة المرور",
                              hintStyle: kHintTextStyle,
                              contentPadding: EdgeInsets.only(top: 15),
                              ),
                            ),
                            ),
                          ),
                          Container(
                        height: 60,
                        decoration: kBoxDecorationStyle2.copyWith(borderRadius: BorderRadius.circular(50)),
                        width: size.width - 40,
                        child: ElevatedButton(onPressed: (){
                          setState(() {
                            _load = true;
                          });
                          if(_nameTextEditingConroller.text.isEmpty || _nameTextEditingConroller.text.length < 3)
                          {
                            Fluttertoast.showToast(msg: "الاسم لا يمكن ان يكون فارغاً ويجب ان يحتوي على 3 احرف على الاقل");
                            setState(() {
                              _load = false;
                            });
                          }
                          else if(_emailTextEditingConroller.text.isEmpty || _emailTextEditingConroller.text.length < 5)
                          {
                            Fluttertoast.showToast(msg: "يجب ادخال بريد الكتروني صحيح");
                            setState(() {
                              _load = false;
                            });
                          }
                          else if(_passwordTextEditingConroller.text.isEmpty || _passwordTextEditingConroller.text.length < 7)
                          {
                            Fluttertoast.showToast(msg: "كلمة المرور يجب ان تتكون من 7 احرف على الاقل");
                            setState(() {
                              _load = false;
                            });
                          }
                          else{
                            AuthService().reigester(_emailTextEditingConroller.text.trim(), _passwordTextEditingConroller.text.trim(), _nameTextEditingConroller.text.trim()).then((va) async {
                              var uu = await FirebaseFirestore.instance.collection('Users').doc(va!.user!.uid).get();
                              sharedPrefs.uid = uu['uid'];
                              sharedPrefs.loggedin = true;
                              FirebaseFirestore.instance.collection('Users').doc(va.user!.uid).update({"cride" : ""});                             
                            }).whenComplete((){
                              sharedPrefs.name = _nameTextEditingConroller.text.trim();
                              sharedPrefs.email = _emailTextEditingConroller.text.trim();
                              sharedPrefs.driver = false;                    
                              setState(() {
                                _load = false;
                              });
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompleteRegister())); 
                            });
                          }
                        }, child: Text("تسجيل"), style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      textStyle: TextStyle(
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                      ),),
                     ),
                     SizedBox(height: 30.0,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text("لديك حساب؟", style: TextStyle(fontSize: 18),),
                         SizedBox(width: 5.0),
                         GestureDetector(
                           child: Text("دخول", style: TextStyle(fontSize: 20, decoration: TextDecoration.underline,),),
                           onTap: (){
                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                           },
                         ),
                       ],
                     ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    height: 50,
                    child: AdWidget(ad: banner!),
                  ),
                ],
              ),
            ),
            if(_load)
            Container(
              color: Colors.black.withOpacity(0.50),
              child: Center(child: CircularProgressIndicator(),),
            ),
          ],
        ),
        ),
      );
    } else {
      return Container();
    }
  }
}
