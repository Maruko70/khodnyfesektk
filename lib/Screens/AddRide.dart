
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khodnyfesektk/Screens/Navbar.dart';
import 'package:khodnyfesektk/Services/shared.dart';

import '../consts.dart';

class AddRideScreen extends StatefulWidget {
  const AddRideScreen({ Key? key }) : super(key: key);

  @override
  _AddRideScreenState createState() => _AddRideScreenState();
}

class _AddRideScreenState extends State<AddRideScreen> {
  TextEditingController _fromTextEditingController = TextEditingController();
  TextEditingController _toTextEditingController = TextEditingController();
  int _psgTextEditingController = 1;

  late DateTime pickedDate;
  late TimeOfDay pickedTime;

  bool _load = false;

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    pickedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("اضافة رحلة", style: TextStyle(fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        bottomNavigationBar: Navbar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(height: 30.0,),
                    Text("مكان الانطلاق", style: TextStyle(fontSize: 20,),),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: kBoxDecorationStyle2,
                                    height: 60.0,
                                     child: TextFormField(
                                       controller: _fromTextEditingController,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                        color: Colors.black, 
                                      ),
                                    decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.directions, color: Colors.black,),
                                    hintText: "ادخل مكان الانطلاق",
                                    hintStyle: kHintTextStyle,
                                    contentPadding: EdgeInsets.only(top: 15),
                                    ),
                                  ),
                                  ),
                        ),
                        SizedBox(height: 30.0,),
                    Text("الوجهة", style: TextStyle(fontSize: 20,),),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: kBoxDecorationStyle2,
                                    height: 60.0,
                                     child: TextFormField(
                                       controller: _toTextEditingController,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                        color: Colors.black, 
                                      ),
                                    decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.place, color: Colors.black,),
                                    hintText: "ادخل وجهتك",
                                    hintStyle: kHintTextStyle,
                                    contentPadding: EdgeInsets.only(top: 15),
                                    ),
                                  ),
                                  ),
                        ),
                        SizedBox(height: 30.0,),
                        Text("عدد الركاب", style: TextStyle(fontSize: 20,),),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Container(
                           margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(child: IconButton(onPressed: (){
                                  setState(() {
                                    if(_psgTextEditingController <= 9)
                                    _psgTextEditingController++;
                                  });
                                }, icon: Icon(Icons.add)), decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [
                                BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6.0,
                                offset: Offset(0, 2),
                                  ),
                                ],),),
                                SizedBox(width: 20,),
                                Text("$_psgTextEditingController", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),),
                                SizedBox(width: 20,),
                                Container(child: IconButton(onPressed: (){
                                  setState(() {
                                    if(_psgTextEditingController >= 2)
                                    _psgTextEditingController--;
                                  });
                                }, icon: Icon(Icons.remove)), decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [
                                BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6.0,
                                offset: Offset(0, 2),
                                  ),
                                ],),),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30.0),
                      Text("تاريخ الرحلة", style: TextStyle(fontSize: 20,),),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Container(
                         margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                         decoration: BoxDecoration(color: Colors.white,
                         borderRadius: BorderRadius.circular(10.0),
                         boxShadow: [
                         BoxShadow(
                         color: Colors.black12,
                         blurRadius: 6.0,
                         offset: Offset(0, 2),
                          ),
                         ],),
                          child: ListTile(
                            title: Text("Date: ${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day} / Time : ${pickedTime.hour} : ${pickedTime.minute}", textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),
                            trailing: Icon(Icons.keyboard_arrow_down),
                            onTap: _pickDate,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0,),
                      Container(
                        child: TextButton(onPressed: () async{
                          setState(() {
                            _load = true;
                          });
                          if(_fromTextEditingController.text.isEmpty || _toTextEditingController.text.isEmpty){
                            setState(() {
                              _load = false;
                            });
                            showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) => CupertinoAlertDialog(
                              title: new Text("فشل!", style: TextStyle(color: Colors.red, fontFamily: "Tajawal Bold"), textDirection: TextDirection.rtl),
                              content: new Text("لا يمكنك اضافة رحلة بدون اضافة عناوين.", style: TextStyle(fontFamily: "Tajawal Regular",), textDirection: TextDirection.rtl,),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: Text("موافق"),
                                  onPressed: (){ Navigator.pop(context);},
                                ),
                              ],
                            )
                          );
                          }
                          else if(!sharedPrefs.driver){
                            setState(() {
                              _load = false;
                            });
                            showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) => CupertinoAlertDialog(
                              title: new Text("فشل!", style: TextStyle(color: Colors.red, fontFamily: "Tajawal Bold"), textDirection: TextDirection.rtl),
                              content: new Text("يمكن للسائقين فقط اضافة رحلات.", style: TextStyle(fontFamily: "Tajawal Regular",), textDirection: TextDirection.rtl,),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: Text("موافق"),
                                  onPressed: (){ Navigator.pop(context);},
                                ),
                              ],
                            )
                          );
                          
                          }
                          else{
                            List<dynamic> rpsg = [];
                          var rides = await FirebaseFirestore.instance.collection('Rides').add({"uid" : sharedPrefs.uid});
                          var uu = await FirebaseFirestore.instance.collection('Users').doc(sharedPrefs.uid).get();
                          rides.set({
                            "rid" : rides.id,
                            "from" : _fromTextEditingController.text.trim(),
                            "to" : _toTextEditingController.text.trim(),
                            "psg" : _psgTextEditingController,
                            "cpsg" : 0,
                            "date" : "${pickedDate.month}/${pickedDate.day}",
                            "time" : "${pickedTime.format(context)}",
                            "uid" : sharedPrefs.uid,
                            "name" : sharedPrefs.name,
                            "smoker" : uu['acceptSmoker'],
                            "rpsg" : rpsg,
                            "status" : "waiting"
                          }).whenComplete((){
                            setState(() {
                              _load = false;
                            });
                            showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) => CupertinoAlertDialog(
                              title: new Text("نجاح!", style: TextStyle(color: Colors.green, fontFamily: "Tajawal Bold"), textDirection: TextDirection.rtl),
                              content: new Text("تم إضافة رحلتك بنجاح.", style: TextStyle(fontFamily: "Tajawal Regular",), textDirection: TextDirection.rtl,),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: Text("موافق"),
                                  onPressed: (){ Navigator.pop(context);},
                                ),
                              ],
                            )
                          );
                          }
                          );
                          }
                        }, child: Text("إضافة",  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold,),),),
                        decoration: kBoxDecorationStyle2,
                        width: 250.0,
                        ),
                  ],
                ),
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

  _pickDate() async{
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year-5), 
      lastDate: DateTime(DateTime.now().year+5)
      );

    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),);
    
    if(date != null){
      setState(() {
        pickedDate = date;
      });
    }
    if(time != null){
      setState(() {
        pickedTime = time;
      });
    }
  }
}