import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:khodnyfesektk/Screens/Navbar.dart';
import 'package:khodnyfesektk/Services/shared.dart';
import 'package:khodnyfesektk/consts.dart';
import 'package:provider/provider.dart';

import '../ad_state.dart';

class TopRatings extends StatefulWidget {
  const TopRatings({Key? key}) : super(key: key);

  @override
  _TopRatingsState createState() => _TopRatingsState();
}

class _TopRatingsState extends State<TopRatings> {
  BannerAd? banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initilization.then((status) {
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("اعلى التقييمات",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        bottomNavigationBar: Navbar(),
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .where('rating', isGreaterThan: 3.5)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              print(sharedPrefs.uid);
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var ds = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: kBoxDecorationStyle2,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  ClipOval(
                                      child: Image.network(
                                    ds['pp'] != null
                                        ? ds['pp']
                                        : "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg",
                                    width: 75,
                                    height: 75,
                                  )),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Column(
                                    children: [
                                      Text(ds['name']),
                                      SizedBox(height: 10.0),
                                      Text(ds['carType']),
                                    ],
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.yellow, size: 20),
                                      Text(ds['rating'].toString()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              child: new AdWidget(ad: banner!),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
