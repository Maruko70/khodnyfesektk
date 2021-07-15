import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:khodnyfesektk/Services/auth.dart';
import 'package:khodnyfesektk/Services/shared.dart';
import 'package:khodnyfesektk/ad_state.dart';
import 'package:provider/provider.dart';

import '../consts.dart';
import 'CompleteRegisterScreen.dart';
import 'HomeScreen.dart';
import 'Profile.dart';
import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  
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
    return Scaffold(
      body: Directionality(textDirection: TextDirection.rtl, 
        child: Stack(
          children: [
            Container(
              color: Colors.yellow,
              height: size.height,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: size.height / 3.5),
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
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompleteRegister()));
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
                          if(sharedPrefs.gender.length < 4)
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompleteRegister()));
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
                          if(_emailTextEditingConroller.text.isEmpty || _emailTextEditingConroller.text.length < 5)
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
                            AuthService().signIn(_emailTextEditingConroller.text.trim(), _passwordTextEditingConroller.text.trim()).whenComplete((){
                              sharedPrefs.loggedin = true;
                              setState(() {
                                _load = false;
                              });
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen())); 
                            });
                          }
                        }, child: Text("دخول"), style: ElevatedButton.styleFrom(
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
                         Text("ليس لديك حساب؟", style: TextStyle(fontSize: 18),),
                         SizedBox(width: 5.0),
                         GestureDetector(
                           child: Text("سجل الآن", style: TextStyle(fontSize: 20, decoration: TextDecoration.underline,),),
                           onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
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
                  )
                ],
              ),
            ),
            if(_load)
            Container(
              color: Colors.black.withOpacity(0.50),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
        ),
    );
  }
}