import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_rating_bar/flutter_simple_rating_bar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:khodnyfesektk/Screens/ChatScreen.dart';
import 'package:khodnyfesektk/Services/shared.dart';
import 'package:provider/provider.dart';

import '../ad_state.dart';
import '../consts.dart';
import 'HomeScreen.dart';

class GoingRide extends StatefulWidget {
  const GoingRide({ Key? key, required this.id, required this.did }) : super(key: key);

  final String id, did;

  @override
  _GoingRideState createState() => _GoingRideState();
}

class _GoingRideState extends State<GoingRide> {

  bool _load = false;

  String dName = "none";
  String dPP = "none";
  String dPhone = "none";
  String dCar = "none";
  Icon unrated1 = Icon(Icons.star_border, color: Colors.yellow);
  Icon rated1 = Icon(Icons.star, color: Colors.yellow);
  Icon unrated2 = Icon(Icons.star_border, color: Colors.yellow);
  Icon unrated3 = Icon(Icons.star_border, color: Colors.yellow);
  Icon unrated4 = Icon(Icons.star_border, color: Colors.yellow);
  Icon unrated5 = Icon(Icons.star_border, color: Colors.yellow);

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
    setState(() {
      _load = true;
    });
    super.initState();
    FirebaseFirestore.instance.collection('Users').doc(widget.did).get().then((value){
      setState(() {
        dName = value['name'];
        dPP = value['pp'] == null ? "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg" : value['pp'];
        dPhone = value['phone'];
        dCar = value['carNo'];
      });
    }).whenComplete((){
      setState(() {
        _load = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Directionality(textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("الرحلة الحالية", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Rides').where('rid', isEqualTo: widget.id).snapshots(),
                builder: (context, snap){
                  if(!snap.hasData){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  return Container(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30.0,),
                            Row(
                              children: [
                                Text("تفاصيل السائق", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                                SizedBox(width: size.width - 300),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text("محادثة الرحلة"),
                                      IconButton(icon: Icon(Icons.message), onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(id: widget.id)));
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0,),
                            Container(
                              decoration: kBoxDecorationStyle2,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    ClipOval(
                                      child: CachedNetworkImage(imageUrl: dPP, height: 75, width: 75,),
                                    ),
                                    SizedBox(width: 10.0,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(dName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                        SizedBox(height: 5.0,),
                                        Text(dPhone, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                        SizedBox(height: 5.0,),
                                        Text("رقم السيارة : $dCar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                      ],
                                    ),
                                    Spacer(),
                                    //IconButton(onPressed: null, icon: Icon(Icons.arrow_forward_ios)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 30.0,),
                            Text("تفاصيل الرحلة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                            SizedBox(height: 30.0,),
                            Container(
                              child: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance.collection('Rides').doc(widget.id).snapshots(),
                                builder: (context, snapshot){
                                  if(!snapshot.hasData){
                                    return Center(child: CircularProgressIndicator(),);
                                  }
                                  return snapshot.data!['status'] == "going" ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text("من : ${snapshot.data!['from']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                          SizedBox(width: 30.0,),
                                          Text("الى : ${snapshot.data!['to']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                        ],
                                      ),
                                      SizedBox(height: 30.0,),
                                      Text("تاريخ الرحلة : ${snapshot.data!['date']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                      SizedBox(height: 30.0,),
                                      Text("زمن الرحلة : ${snapshot.data!['time']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                      SizedBox(height: 30.0,),
                                      Text("عدد الركاب : ${snapshot.data!['cpsg']}/${snapshot.data!['psg']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                    ],
                                  ) : snapshot.data!['status'] == "rating" ? Center(
                                    child: Column(
                                      children: [
                                        if(widget.did != sharedPrefs.uid)
                                        Text("الرجاء تقييم السائق $dName"),
                                        if(widget.did != sharedPrefs.uid)
                                        SizedBox(height: 30.0,),
                                        if(widget.did != sharedPrefs.uid)
                                        RatingBar(
                                          rating: 0,
                                          icon:Icon(Icons.star,size:40,color: Colors.grey,),
                                          starCount: 5,
                                          spacing: 5.0,
                                          size: 40,
                                          isIndicator: false,
                                          allowHalfRating: true,
                                          onRatingCallback: (double value,ValueNotifier<bool> isIndicator){
                                            FirebaseFirestore.instance.collection('Users').doc(widget.did).get().then((val){
                                              if(value == 1){
                                                FirebaseFirestore.instance.collection('Users').doc(widget.did).update({
                                                "rating1" : val['rating1'] + 1,
                                                "rating2" : val['rating2'],
                                                "rating3" : val['rating3'],
                                                "rating4" : val['rating4'],
                                                "rating5" : val['rating5'],
                                              });
                                              }
                                              if(value == 2){
                                                FirebaseFirestore.instance.collection('Users').doc(widget.did).update({
                                                "rating1" : val['rating1'],
                                                "rating2" : val['rating2'] + 1,
                                                "rating3" : val['rating3'],
                                                "rating4" : val['rating4'],
                                                "rating5" : val['rating5'],
                                              });
                                              }
                                              if(value == 3){
                                                FirebaseFirestore.instance.collection('Users').doc(widget.did).update({
                                                "rating1" : val['rating1'],
                                                "rating2" : val['rating2'],
                                                "rating3" : val['rating3'] + 1,
                                                "rating4" : val['rating4'],
                                                "rating5" : val['rating5'],
                                                
                                              });
                                              }
                                              if(value == 4){
                                                FirebaseFirestore.instance.collection('Users').doc(widget.did).update({
                                                "rating1" : val['rating1'],
                                                "rating2" : val['rating2'],
                                                "rating3" : val['rating3'],
                                                "rating4" : val['rating4'] + 1,
                                                "rating5" : val['rating5'],
                                              });
                                              }
                                              if(value == 5){
                                                FirebaseFirestore.instance.collection('Users').doc(widget.did).update({
                                                "rating1" : val['rating1'],
                                                "rating2" : val['rating2'],
                                                "rating3" : val['rating3'],
                                                "rating4" : val['rating4'],
                                                "rating5" : val['rating5'] + 1,
                                              });
                                              }
                                                FirebaseFirestore.instance.collection('Users').doc(widget.did).update({
                                                  "rating" : (5*val['rating5'] + 4*val['rating4'] + 3*val['rating3'] + 2*val['rating2'] + 1*val['rating1']) / (val['rating5']+val['rating4']+val['rating3']+val['rating2']+val['rating1'])
                                                });
                                            });
                                            isIndicator.value=true;
                                            showCupertinoDialog(
                                            context: context,
                                            builder: (BuildContext context) => CupertinoAlertDialog(
                                              title: new Text("شكراً!", style: TextStyle(color: Colors.green, fontFamily: "Tajawal Bold"), textDirection: TextDirection.rtl),
                                              content: new Text("شكراً لتقييمك ومساهمتك في تحسين التطبيق.", style: TextStyle(fontFamily: "Tajawal Regular",), textDirection: TextDirection.rtl,),
                                              actions: <Widget>[
                                                CupertinoDialogAction(
                                                  child: Text("موافق"),
                                                  onPressed: (){ 
                                                    FirebaseFirestore.instance.collection('Rides').doc(widget.id).get().then((value){
                                                      List<String> rpsg = [];
                                                      for(int i = 0; i < value['cpsg']; i++){
                                                        FirebaseFirestore.instance.collection('Users').doc(value['rpsg'][i]).update({
                                                          "urides" : rpsg,
                                                          "cride" : "",
                                                        });
                                                      }
                                                      FirebaseFirestore.instance.collection('Users').doc(widget.did).update({
                                                        "urides" : rpsg,
                                                        "cride" : "",
                                                        });
                                                    });
                                                    FirebaseFirestore.instance.collection('Rides').doc(widget.id).update({"status" : "completed"});
                                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));},
                                                ),
                                              ],
                                            )
                                          );
                                          },
                                          color: Colors.amber,
                                        ),
                                      ],
                                    ),
                                  ) : Container();
                                },
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              height: 50,
                              child: AdWidget(ad: banner!,),
                            ),
                            if(widget.did == sharedPrefs.uid)
                            Container(
                              width: size.width - 40,
                              decoration: kBoxDecorationStyle2,
                              child: TextButton(onPressed: (){
                                  FirebaseFirestore.instance.collection('Rides').doc(widget.id).get().then((value){
                                    for(int i = 0; i < value['cpsg']; i++){
                                      List<String> rpsg = [];
                                      FirebaseFirestore.instance.collection('Users').doc(value['rpsg'][i]).update({"rpsg" : rpsg});
                                    }
                                  });
                                  FirebaseFirestore.instance.collection('Users').doc(sharedPrefs.uid).update({"cride" : ""});
                                  FirebaseFirestore.instance.collection('Rides').doc(widget.id).update({"status" : "rating"});
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                              }, child: Text("انهاء الرحلة", style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold,)))),
                          ],
                        ),
                      ),
                    );
                },
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
}