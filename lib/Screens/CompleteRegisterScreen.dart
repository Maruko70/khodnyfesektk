import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khodnyfesektk/Screens/Profile.dart';
import 'package:khodnyfesektk/Services/shared.dart';
import 'package:khodnyfesektk/consts.dart';

class CompleteRegister extends StatefulWidget {
  const CompleteRegister({ Key? key,}) : super(key: key);

  @override
  _CompleteRegisterState createState() => _CompleteRegisterState();
}

class _CompleteRegisterState extends State<CompleteRegister> {
  BoxDecoration male = unchoosen;
  BoxDecoration female = unchoosen;
  BoxDecoration issmoker = unchoosen;
  BoxDecoration nonsmoker = unchoosen;
  String gender = "none";
  bool smoker = false;
  TextEditingController _phoneTextEditingConroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Directionality(textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          color: Colors.yellow,
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ادخل رقم الهاتف الخاص بك", style: TextStyle(fontSize: 20,),),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                              alignment: Alignment.centerLeft,
                              decoration: kBoxDecorationStyle2,
                              height: 60.0,
                               child: TextFormField(
                                 controller: _phoneTextEditingConroller,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                  color: Colors.black, 
                                ),
                              decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.phone, color: Colors.black,),
                              hintText: "ادخل رقم الهاتف",
                              hintStyle: kHintTextStyle,
                              contentPadding: EdgeInsets.only(top: 15),
                              ),
                            ),
                            ),
                  ),
                  SizedBox(height: 30,),
                  Text("يرجى تحديد جنسك", style: TextStyle(fontSize: 20,),),
                  SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      GestureDetector(
                        onTap: (){setState(() {
                          male = choosen;
                          female = unchoosen;
                          gender = "male";
                        });},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 75,
                            height: 50,
                            decoration: male,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Text("ذكر"),
                              Icon(Icons.male),
                            ],),
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: (){setState(() {
                          female = choosen;
                          male = unchoosen;
                          gender = "female";
                        });},
                        child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: female,
                          width: 75,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text("انثى"),
                            Icon(Icons.female),
                          ],),
                        ),
                      ),
                      ),
                    ],),
                  ),
                  SizedBox(height: 10.0,),
                  Text("هل تقوم بالتدخين؟", style: TextStyle(fontSize: 20,),),
                  SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      GestureDetector(
                        onTap: (){setState(() {
                          issmoker = choosen;
                          nonsmoker = unchoosen;
                          smoker = true;
                        });},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 75,
                            height: 50,
                            decoration: issmoker,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Text("نعم "),
                              Icon(Icons.smoking_rooms),
                            ],),
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: (){setState(() {
                          nonsmoker = choosen;
                          issmoker = unchoosen;
                          smoker = false;
                        });},
                        child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: nonsmoker,
                          width: 75,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text("لا "),
                            Icon(Icons.smoke_free),
                          ],),
                        ),
                      ),
                      ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 20.0,
                right: 20.0,
                child: Container(
                  height: 60,
                  decoration: kBoxDecorationStyle2.copyWith(borderRadius: BorderRadius.circular(50)),
                  width: size.width - 40,
                  child: ElevatedButton(onPressed: (){
                    if(gender == "none" && _phoneTextEditingConroller.text.isEmpty || _phoneTextEditingConroller.text.length < 10 )
                    Fluttertoast.showToast(msg: "يجب الاجابة على كافة الحقول");
                    else if(_phoneTextEditingConroller.text.isEmpty || _phoneTextEditingConroller.text.length < 10)
                    Fluttertoast.showToast(msg: "يجب ادخال رقم هاتف صحيح");
                    else if(gender == "none")
                    Fluttertoast.showToast(msg: "يجب تحديد جنسك");
                    else{
                      FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).set({
                        "uid" : FirebaseAuth.instance.currentUser!.uid,
                        "name" : sharedPrefs.name,
                        "email" : sharedPrefs.email, 
                        "pp" : FirebaseAuth.instance.currentUser!.photoURL,
                        "gender" : gender,
                        "smoker" : smoker,
                        "driver" : sharedPrefs.driver,
                        "phone" : _phoneTextEditingConroller.text
                      });
                      sharedPrefs.gender = gender;
                      sharedPrefs.smoker = smoker;
                      sharedPrefs.phone = _phoneTextEditingConroller.text.trim();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen())); 
                    }
                  }, child: Text("متابعة"), style: ElevatedButton.styleFrom(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String validateMobile(String value) {
    if (value.length != 10)
      return 'رقم الهاتف يجب ان يكون من 10 ارقام';
    else
      return '';
  }
