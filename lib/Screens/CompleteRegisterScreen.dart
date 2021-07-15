import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khodnyfesektk/Screens/Profile.dart';
import 'package:khodnyfesektk/Services/shared.dart';
import 'package:khodnyfesektk/consts.dart';

import 'HomeScreen.dart';

class CompleteRegister extends StatefulWidget {
  final bool? driver;
  const CompleteRegister({ Key? key, this.driver = false,}) : super(key: key);

  @override
  _CompleteRegisterState createState() => _CompleteRegisterState();
}

class _CompleteRegisterState extends State<CompleteRegister> {
  BoxDecoration male = unchoosen;
  BoxDecoration female = unchoosen;
  BoxDecoration issmoker = unchoosen;
  BoxDecoration nonsmoker = unchoosen;
  BoxDecoration issmoker2 = unchoosen;
  BoxDecoration nonsmoker2 = unchoosen;
  BoxDecoration ispickup = unchoosen;
  BoxDecoration nopickup = unchoosen;
  String gender = "none";
  bool smoker = false;
  bool smoker2 = false;
  bool pickup = false;
  TextEditingController _phoneTextEditingConroller = TextEditingController();
  TextEditingController _brandTextEditingConroller = TextEditingController();
  TextEditingController _noTextEditingConroller = TextEditingController();
  TextEditingController _lesTextEditingConroller = TextEditingController();
  TextEditingController _idTextEditingConroller = TextEditingController();

  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print(ModalRoute.of(context)!.settings.name);
    return Directionality(textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("اكمال التسجيل", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: Container(
          color: Colors.yellow,
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ادخل رقم الهاتف الخاص بك", style: TextStyle(fontSize: 20,),),
                SizedBox(height: 5,),
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
                SizedBox(height: 10,),
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
                if(widget.driver!)
                Column(
                  children: [
                    SizedBox(height: 10,),
                Text("ادخل رقم البطاقة", style: TextStyle(fontSize: 20,),),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                            alignment: Alignment.centerLeft,
                            decoration: kBoxDecorationStyle2,
                            height: 60.0,
                             child: TextFormField(
                               controller: _idTextEditingConroller,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                color: Colors.black, 
                              ),
                            decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.money, color: Colors.black,),
                            hintText: "ادخل رقم البطاقة الشخصية",
                            hintStyle: kHintTextStyle,
                            contentPadding: EdgeInsets.only(top: 15),
                            ),
                          ),
                          ),
                ),
                SizedBox(height: 10,),
                Text("ادخل رقم الرخصة", style: TextStyle(fontSize: 20,),),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                            alignment: Alignment.centerLeft,
                            decoration: kBoxDecorationStyle2,
                            height: 60.0,
                             child: TextFormField(
                               controller: _lesTextEditingConroller,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                color: Colors.black, 
                              ),
                            decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.money, color: Colors.black,),
                            hintText: "ادخل رقم الرخصة",
                            hintStyle: kHintTextStyle,
                            contentPadding: EdgeInsets.only(top: 15),
                            ),
                          ),
                          ),
                ),
                    SizedBox(height: 10,),
                    Text("ادخل نوع او ماركة السيارة", style: TextStyle(fontSize: 20,),),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                            alignment: Alignment.centerLeft,
                            decoration: kBoxDecorationStyle2,
                            height: 60.0,
                             child: TextFormField(
                               controller: _brandTextEditingConroller,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                color: Colors.black, 
                              ),
                            decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.drive_eta_rounded, color: Colors.black,),
                            hintText: "ادخل نوع السيارة",
                            hintStyle: kHintTextStyle,
                            contentPadding: EdgeInsets.only(top: 15),
                            ),
                          ),
                          ),
                ),
                SizedBox(height: 10,),
                Text("ادخل رقم لوحة السيارة", style: TextStyle(fontSize: 20,),),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                            alignment: Alignment.centerLeft,
                            decoration: kBoxDecorationStyle2,
                            height: 60.0,
                             child: TextFormField(
                               controller: _noTextEditingConroller,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                color: Colors.black, 
                              ),
                            decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.money, color: Colors.black,),
                            hintText: "ادخل رقم السيارة",
                            hintStyle: kHintTextStyle,
                            contentPadding: EdgeInsets.only(top: 15),
                            ),
                          ),
                          ),
                ),
                SizedBox(height: 10,),
                    Text("ماهو نوع السيارة؟", style: TextStyle(fontSize: 20,),),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    GestureDetector(
                      onTap: (){setState(() {
                        ispickup = choosen;
                        nopickup = unchoosen;
                        pickup = true;
                      });},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 75,
                          height: 50,
                          decoration: ispickup,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text("نقل"),
                          ],),
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: (){setState(() {
                        nopickup = choosen;
                        ispickup = unchoosen;
                        pickup = false;
                      });},
                      child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: nopickup,
                        width: 75,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text("عادي"),
                        ],),
                      ),
                    ),
                    ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0,),
                Text("هل تقبل رحلات من مدخنين؟", style: TextStyle(fontSize: 20,),),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    GestureDetector(
                      onTap: (){setState(() {
                        issmoker2 = choosen;
                        nonsmoker2 = unchoosen;
                        smoker2 = true;
                      });},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 75,
                          height: 50,
                          decoration: issmoker2,
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
                        nonsmoker2 = choosen;
                        issmoker2 = unchoosen;
                        smoker2 = false;
                      });},
                      child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: nonsmoker2,
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
                SizedBox(height: 10,),
                Container(
                  height: 60,
                  decoration: kBoxDecorationStyle2.copyWith(borderRadius: BorderRadius.circular(50)),
                  width: size.width - 40,
                  child: ElevatedButton(onPressed: (){
                    if(gender == "none" && _phoneTextEditingConroller.text.isEmpty || _phoneTextEditingConroller.text.length < 10 || _noTextEditingConroller.text.isEmpty && widget.driver! || _brandTextEditingConroller.text.isEmpty && widget.driver!)
                    Fluttertoast.showToast(msg: "يجب الاجابة على كافة الحقول");
                    else if(_phoneTextEditingConroller.text.isEmpty || _phoneTextEditingConroller.text.length < 10)
                    Fluttertoast.showToast(msg: "يجب ادخال رقم هاتف صحيح");
                    else if(gender == "none")
                    Fluttertoast.showToast(msg: "يجب تحديد جنسك");
                    else{
                      if(widget.driver!){
                        FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).set({
                        "uid" : FirebaseAuth.instance.currentUser!.uid,
                        "name" : sharedPrefs.name,
                        "email" : sharedPrefs.email, 
                        "pp" : FirebaseAuth.instance.currentUser!.photoURL,
                        "gender" : gender,
                        "smoker" : smoker,
                        "driver" : true,
                        "phone" : _phoneTextEditingConroller.text.trim(),
                        "pickup" : pickup,
                        "carType" : _brandTextEditingConroller.text.trim(),
                        "carNo" : _noTextEditingConroller.text.trim(),
                        "acceptSmoker" : smoker2,
                        "lesNo" : _lesTextEditingConroller.text.trim(),
                        "idNo" : _idTextEditingConroller.text.trim()
                      });
                      }
                      else{
                        FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).set({
                        "uid" : FirebaseAuth.instance.currentUser!.uid,
                        "name" : sharedPrefs.name,
                        "email" : sharedPrefs.email, 
                        "pp" : FirebaseAuth.instance.currentUser!.photoURL,
                        "gender" : gender,
                        "smoker" : smoker,
                        "driver" : false,
                        "phone" : _phoneTextEditingConroller.text.trim(),
                      });
                      }
                      sharedPrefs.gender = gender;
                      sharedPrefs.smoker = smoker;
                      sharedPrefs.phone = _phoneTextEditingConroller.text.trim();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen())); 
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
            SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

