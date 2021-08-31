
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:khodnyfesektk/Screens/Navbar.dart';
import 'package:khodnyfesektk/Services/shared.dart';
import 'package:khodnyfesektk/consts.dart';
import 'package:provider/provider.dart';
import '../ad_state.dart';
import 'GoingRide.dart';
import 'RideDetails.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var fride = "";
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
  void initState() {
    super.initState();    
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('Users').doc(sharedPrefs.uid).snapshots(),
      builder: (context, snaps){
        if(!snaps.hasData){
          return Center(child: CircularProgressIndicator(semanticsLabel: "Waiting",),);
        }
        if(!sharedPrefs.driver){
          if(snaps.data!['driver'] == true){
            sharedPrefs.driver = true;
          }
        }
        if(!snaps.data!.data()!.containsKey('cride')){
          FirebaseFirestore.instance.collection('Users').doc(sharedPrefs.uid).update({"cride" : ""});
        }
        if(!snaps.data!.data()!.containsKey('crides')){
          FirebaseFirestore.instance.collection('Users').doc(sharedPrefs.uid).update({"crides" : 0});
        }
        return snaps.data!['cride'] != ""  ? StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('Rides').doc(snaps.data!['cride']).snapshots(),
      builder: (context, snap){
        if(!snap.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        return snap.data!['status'] == "going" || snap.data!['status'] == "rating" 
      ? GoingRide(id: snaps.data!['cride'], did: snap.data!['uid']) : Directionality(textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("الرحلات المتوفرة", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: Navbar(),
        body:  StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Rides').where('status', isEqualTo: 'waiting').snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(),);
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){
                          var ds = snapshot.data!.docs[index];
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => RideDetails(id: ds.id, uid: ds['uid'])));},
                                child: RideCard(name: ds['name'], from: ds['from'], to: ds['to'], date: ds['date'], time: ds['time'], psg: ds['psg'], cpsg: ds['cpsg'], duid: ds['uid'], id: ds.id, status: ds['status'], smoker: ds['smoker'])),
                                if(banner != null)
                                Container(
                                  height: 50,
                                  child: new AdWidget(ad: banner!,),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    if(banner == null)
                    SizedBox(height: 50)
                    else
                    Container(
                      height: 50,
                      child: new AdWidget(ad: banner!,),
                    )
                  ],
                );
              }
        ),
        ),
      );
      },
      ) : Directionality(textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("الرحلات المتوفرة", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: Navbar(),
        body: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: sharedPrefs.driver ? FirebaseFirestore.instance.collection('Rides').where('status', isNotEqualTo: 'completed').snapshots() : FirebaseFirestore.instance.collection('Rides').where('status', isEqualTo: 'waiting').snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(),);
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){
                          var ds = snapshot.data!.docs[index];
                          return GestureDetector(
                            onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => RideDetails(id: ds.id, uid: ds['uid'])));},
                            child: RideCard(name: ds['name'], from: ds['from'], to: ds['to'], date: ds['date'], time: ds['time'], psg: ds['psg'], cpsg: ds['cpsg'], duid: ds['uid'], id: ds.id, status: ds['status'], smoker: ds['smoker']));
                        },
                      ),
                    ),
                    if(banner == null)
                    SizedBox(height: 50)
                    else
                    Container(
                      height: 50,
                      child: new AdWidget(ad: banner!,),
                    )
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );   
      }
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
            height: size.height / 3.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.0,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                    Flexible(child: Text("اسم السائق : ${widget.name}")),
                    Spacer(),
                    Flexible(child: Text("تاريخ الرحلة : ${widget.date}")),
                  ],),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                    Flexible(child: Text("من : ${widget.from}")),
                    Spacer(),
                    Spacer(),
                    Flexible(child: Text("الى : ${widget.to}")),
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
                Container(width: 300.0, child: TextButton(child: buttonChild, onPressed: (){
                  setState(() {
                    buttonChild = CircularProgressIndicator();
                  });
                  FirebaseFirestore.instance.collection('Users').doc(sharedPrefs.uid).get().then((value){
                    if(value['crides'] >= 2){
                      showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) => CupertinoAlertDialog(
                              title: new Text("فشل!", style: TextStyle(color: Colors.red, fontFamily: GoogleFonts.tajawal().fontFamily, fontWeight: FontWeight.bold), textDirection: TextDirection.rtl),
                              content: new Text("لا يمكنك التسجيل في اكثر من رحلتين في نفس الوقت.", style: TextStyle(fontFamily: GoogleFonts.tajawal().fontFamily,), textDirection: TextDirection.rtl,),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: Text("موافق"),
                                  onPressed: (){ Navigator.pop(context);},
                                ),
                              ],
                            )
                    );
                    setState(() {
                    buttonChild = Text("تسجيل");
                  });
                    }
                    else{
                      if(sharedPrefs.uid == widget.duid){
                        if(widget.status == "waiting" && widget.time!.split(':')[0] == TimeOfDay.now().format(context).split(':')[0])
                        {
                          FirebaseFirestore.instance.collection('Rides').doc(widget.id).update({"status" : "going"});
                          List<String> uridesz = [];
                          uridesz.add(widget.id!);
                          FirebaseFirestore.instance.collection('Users').doc(sharedPrefs.uid).update({"cride" : widget.id!});
                          setState(() {
                            buttonChild = Text("الغاء الرحلة");
                          });
                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GoingRide(id: widget.id!, did: widget.duid!)));
                        }
                        else if(widget.status == "going"){
                                showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext context) => CupertinoAlertDialog(
                                    title: new Text("فشل!", style: TextStyle(color: Colors.red, fontFamily: GoogleFonts.tajawal().fontFamily, fontWeight: FontWeight.bold), textDirection: TextDirection.rtl),
                                    content: new Text("لا يمكنك بدء هذه الرحلة لانها بدئت بالفعل.", style: TextStyle(fontFamily: GoogleFonts.tajawal().fontFamily,), textDirection: TextDirection.rtl,),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: Text("موافق"),
                                        onPressed: (){ Navigator.pop(context);},
                                      ),
                                    ],
                                  )
                          );
                        }
                        else if(widget.time!.split(':')[0] != TimeOfDay.now().format(context).split(':')[0]){
                                 showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext context) => CupertinoAlertDialog(
                                    title: new Text("فشل!", style: TextStyle(color: Colors.red, fontFamily: GoogleFonts.tajawal().fontFamily, fontWeight: FontWeight.bold), textDirection: TextDirection.rtl),
                                    content: new Text("لا يمكنك بدء هذه الرحلة لان وقتها لم يحن بعد.", style: TextStyle(fontFamily: GoogleFonts.tajawal().fontFamily,), textDirection: TextDirection.rtl,),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: Text("موافق"),
                                        onPressed: (){ Navigator.pop(context);},
                                      ),
                                    ],
                                  )
                          );
                        }
                          setState(() {
                    buttonChild = Text("بدء الرحلة");
                  });
                  }
                  else if(widget.psg == widget.cpsg){
                    showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) => CupertinoAlertDialog(
                              title: new Text("فشل!", style: TextStyle(color: Colors.red, fontFamily: GoogleFonts.tajawal().fontFamily, fontWeight: FontWeight.bold), textDirection: TextDirection.rtl),
                              content: new Text("لا يمكنك التسجيل في هذه الرحلة بسبب اكتمال العدد.", style: TextStyle(fontFamily: GoogleFonts.tajawal().fontFamily,), textDirection: TextDirection.rtl,),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: Text("موافق"),
                                  onPressed: (){ Navigator.pop(context);},
                                ),
                              ],
                            )
                    );
                    setState(() {
                    buttonChild = Text("تسجيل");
                  });
                  }
                  else if (buttonChild == Text("الغاء التسجيل")){

                  }
                  else if(!widget.smoker! && sharedPrefs.smoker){
                    showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) => CupertinoAlertDialog(
                              title: new Text("فشل!", style: TextStyle(color: Colors.red, fontFamily: GoogleFonts.tajawal().fontFamily, fontWeight: FontWeight.bold), textDirection: TextDirection.rtl),
                              content: new Text("لا يمكنك التسجيل في هذه لان صاحبها لا يقبل التدخين.", style: TextStyle(fontFamily: GoogleFonts.tajawal().fontFamily,), textDirection: TextDirection.rtl,),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: Text("موافق"),
                                  onPressed: (){ Navigator.pop(context);},
                                ),
                              ],
                            )
                    );
                    setState(() {
                    buttonChild = Text("تسجيل");
                  });
                  }
                  else{
                    
                    List<dynamic> rpsg = [];
                    List<dynamic> urides = [];

                    FirebaseFirestore.instance.collection('Rides').doc(widget.id).get().then((value){
                      setState(() {
                        rpsg = value['rpsg'];
                        if(!rpsg.contains(sharedPrefs.uid)){
                          rpsg.add(sharedPrefs.uid);
                          FirebaseFirestore.instance.collection('Rides').doc(widget.id).update({
                            "cpsg" : widget.cpsg! + 1,
                            "rpsg" : rpsg,
                          });
                          for(int i = 0; i < rpsg.length; i++){
                            FirebaseFirestore.instance.collection('Users').doc(rpsg[i]).update({
                              "cride" : widget.id,
                            });
                          }
                          buttonChild = Text("الغاء التسجيل");
                        }
                        else{
                          rpsg.remove(sharedPrefs.uid);
                          FirebaseFirestore.instance.collection('Rides').doc(widget.id).update({
                            "cpsg" : widget.cpsg! - 1,
                            "rpsg" : rpsg,
                          });
                          for(int i = 0; i < rpsg.length; i++){
                            FirebaseFirestore.instance.collection('Users').doc(rpsg[i]).update({
                              "cride" : "",
                            });
                          }
                          buttonChild = Text("تسجيل");
                        }
                      });
                    });
                    FirebaseFirestore.instance.collection('Users').doc(sharedPrefs.uid).get().then((value){
                      setState(() {
                        urides = value['urides'];
                        if(!urides.contains(widget.id)){
                          urides.add(widget.id);
                        }
                        else{
                          urides.remove(widget.id);
                        }
                      });
                      FirebaseFirestore.instance.collection('Users').doc(sharedPrefs.uid).update({
                        "urides" : urides,
                        "cride" : widget.id!
                      });
                    });
                    
                    
                    /*var rspg = FirebaseFirestore.instance.collection('Users').doc(sharedPrefs.uid).get().then((value){
                      print(value['rpsg']);
                    });
                    if(!rpsg.contains(FirebaseAuth.instance.currentUser!.uid))
                    {
                      rpsg.add(FirebaseAuth.instance.currentUser!.uid);
                      urides.add(widget.id!);
                      FirebaseFirestore.instance.collection('Rides').doc(widget.id).update({
                        "cpsg" : widget.cpsg! + 1,
                        "rpsg" : rpsg,
                      });
                      FirebaseFirestore.instance.collection('Users').doc(sharedPrefs.uid).update({
                        "urides" : urides
                      });
                      setState(() {
                    buttonChild = Text("الغاء التسجيل");
                  });
                    }
                    else{
                      rpsg.remove(FirebaseAuth.instance.currentUser!.uid);
                      urides.remove(widget.duid!);
                      FirebaseFirestore.instance.collection('Rides').doc(widget.id).update({
                        "cpsg" : widget.cpsg! - 1,
                        "rpsg" : rpsg
                      });
                      FirebaseFirestore.instance.collection('Users').doc(sharedPrefs.uid).update({
                        "urides" : urides
                      });*/
                     }
                    }
                  });
                },), decoration: kBoxDecorationStyle,),
              ],
            ),
          ),
        );
        
  }
}