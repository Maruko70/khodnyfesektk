import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:khodnyfesektk/Screens/Navbar.dart';
import 'package:mailer2/mailer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ad_state.dart';
import '../consts.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({ Key? key }) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  TextEditingController _nameTextEditingController = TextEditingController();
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _msgTextEditingController = TextEditingController();


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
    return Directionality(textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("تواصل معنا", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        bottomNavigationBar: Navbar(),
        body: Container(
          child: Column(
            children: [
              SizedBox(height: 30.0,),
              Container(
                width: MediaQuery.of(context).size.width / 2.2,
                height: 35.0,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue,
                      offset: Offset(0, 2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: TextButton(onPressed: () async {
                  try {
    bool launched =
        await launch('fb://profile/106537995027281', forceSafariVC: false, forceWebView: false);
    if (!launched) {
      await launch('https://www.facebook.com/khodnyfskatk', forceSafariVC: false, forceWebView: false);
      }
  } catch (e) {
    await launch('https://www.facebook.com/khodnyfskatk', forceSafariVC: false, forceWebView: false);
  }
                }, child: Row(children: [
                  Icon(Icons.facebook, color: Colors.white),
                  Text("صفحتنا على فيسبوك"),
                ],)),
              ),
              Divider(thickness: 1.2, color: Colors.grey[400]),
              SizedBox(height: 30.0,),
                    Text("الاسم", style: TextStyle(fontSize: 20,),),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: kBoxDecorationStyle2,
                                    height: 60.0,
                                     child: TextFormField(
                                       controller: _nameTextEditingController,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                        color: Colors.black, 
                                      ),
                                    decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "ادخل اسمك بالكامل",
                                    hintStyle: kHintTextStyle,
                                    contentPadding: EdgeInsets.all(15),
                                    ),
                                  ),
                                  ),
                        ),
                        SizedBox(height: 30.0,),
                    Text("البريد الالكتروني", style: TextStyle(fontSize: 20,),),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: kBoxDecorationStyle2,
                                    height: 60.0,
                                     child: TextFormField(
                                       controller: _emailTextEditingController,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                        color: Colors.black, 
                                      ),
                                    decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "ادخل بريدك الالكتروني",
                                    hintStyle: kHintTextStyle,
                                    contentPadding: EdgeInsets.all(15),
                                    ),
                                  ),
                                  ),
                        ),
                        SizedBox(height: 30.0,),
                    Text("رسالتك", style: TextStyle(fontSize: 20,),),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: kBoxDecorationStyle2,
                                    height: 150.0,
                                     child: TextFormField(
                                       controller: _msgTextEditingController,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 20,
                                        maxLength: 2500,
                                        style: TextStyle(
                                        color: Colors.black, 
                                      ),
                                    decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "ادخل رسالتك هنا",
                                    hintStyle: kHintTextStyle,
                                    contentPadding: EdgeInsets.all(15),
                                    ),
                                  ),
                                  ),
                        ),
                        SizedBox(height: 30.0,),
                        Container(child: TextButton(onPressed: ()async{
                          var options = new GmailSmtpOptions()
    ..username = 'wingzteam77@gmail.com'
    ..password = 'mnbmnb22'; // Note: if you have Google's "app specific passwords" enabled,
                                        // you need to use one of those here.
                                        
  // How you use and store passwords is up to you. Beware of storing passwords in plain.

  // Create our email transport.
  var emailTransport = new SmtpTransport(options);

  // Create our mail/envelope.
  var envelope = new Envelope()
    ..from = 'wingzteam77@gmail.com'
    ..recipients.add('looflooy1@gmail.com')
    ..subject = _nameTextEditingController.text.trim()
    ..text = _msgTextEditingController.text;

  // Email it.
  emailTransport.send(envelope)
    .then((envelope) => print('Email sent!'))
    .catchError((e) => print('Error occurred: $e'));
                        }, child: Text("إرسال", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold,)),), decoration: kBoxDecorationStyle2, width: 250.0,),

              Container(
                height: 50,
                child: new AdWidget(ad: banner!,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}