import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khodnyfesektk/Services/shared.dart';

import '../consts.dart';
import 'Navbar.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({ Key? key }) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("اعلى التقييمات", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        bottomNavigationBar: Navbar(),
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Orders').where('did', isEqualTo: sharedPrefs.uid).snapshots(),
            builder: (context, snapshot){
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator(),);
              }
              print(sharedPrefs.uid);
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index){
                  var ds = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: kBoxDecorationStyle2,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          child: Row(
                            children: [
                              ClipOval(child: Image.network(ds['pp'] != null ? ds['pp'] : "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg", width: 75, height: 75,)),
                              SizedBox(width: 10.0,),
                              Column(
                                children: [
                                  Text(ds['name']),
                                  SizedBox(height: 10.0),
                                  Text(ds['carType']),
                                ],
                              ),
                              Spacer(),
                              Row(children: [
                                    Icon(Icons.star, color: Colors.yellow, size: 20),
                                    Text(ds['rating'].toString()),
                                  ],),
                            ],
                          ),
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