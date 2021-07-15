import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khodnyfesektk/Services/shared.dart';

import '../consts.dart';
import 'Navbar.dart';

class RidesHistory extends StatefulWidget {
  const RidesHistory({ Key? key }) : super(key: key);

  @override
  _RidesHistoryState createState() => _RidesHistoryState();
}

class _RidesHistoryState extends State<RidesHistory> {
  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("تاريخ الرحلات", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        bottomNavigationBar: Navbar(),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Rides').where('rpsg', arrayContains: sharedPrefs.uid).snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index){
                var ds = snapshot.data!.docs[index];
                return GestureDetector(
                  //onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => RideDetails(id: ds.id, uid: ds['uid'])));},
                  child: RideCard(name: ds['name'], from: ds['from'], to: ds['to'], date: ds['date'], time: ds['time'], psg: ds['psg'], cpsg: ds['cpsg'], duid: ds['uid'], id: ds.id, status: ds['status'], smoker: ds['smoker']));
              },
            );
          }
        ),
      ),
    );
  }
}

class RideCard extends StatefulWidget {
  const RideCard({ Key? key, this.name, this.from, this.to, this.date, this.time, this.psg, this.cpsg, this.duid, this.id, this.status, this.smoker }) : super(key: key);

  final String? name, from, to, date, time, duid, id, status;
  final bool? smoker;
  final int? psg, cpsg;

  @override
  _RideCardState createState() => _RideCardState();
}

class _RideCardState extends State<RideCard> {
  
  Widget buttonChild = Text("تسجيل");

  @override
  void initState() {
    super.initState();
    buttonChild = widget.duid == sharedPrefs.uid ? Text("بدء الرحلة") : Text("تسجيل");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: kBoxDecorationStyle2,
            width: size.width - 40,
            height: size.height / 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.0,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text("اسم السائق : ${widget.name}"),
                    Spacer(),
                    Text("تاريخ الرحلة : ${widget.date}"),
                  ],),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text("من : ${widget.from}"),
                    Spacer(),
                    Text("الى : ${widget.to}"),
                  ],),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text("الزمن : ${widget.time}"),
                    Spacer(),
                    Text("عدد الركاب : ${widget.psg} / ${widget.cpsg}"),
                  ],),
                ),
                Text(widget.status == "completed" ? "مكتملة" : "بالانتظار"),
                /*Container(width: 300.0, child: TextButton(child: buttonChild, onPressed: (){
                },), decoration: kBoxDecorationStyle,),*/
              ],
            ),
          ),
        );
  }
}
