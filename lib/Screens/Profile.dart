import 'package:flutter/material.dart';
import 'package:khodnyfesektk/Services/auth.dart';
import 'package:khodnyfesektk/Services/shared.dart';
import 'package:khodnyfesektk/consts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({ Key? key }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.yellow,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: sharedPrefs.pp == null ? Image.network(sharedPrefs.pp, width: 100) : Image.network("https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg", width: 100),
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(sharedPrefs.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
                SizedBox(width: 10,),
                sharedPrefs.gender == "male" ? Icon(Icons.male) : sharedPrefs.gender == "female" ? Icon(Icons.female) : Text(""),
              ],
            ),
            Text(sharedPrefs.email, style: TextStyle(fontSize: 16,),),
            TextButton(onPressed: (){AuthService().logOut(context);}, child: Text("Logout", style: TextStyle(color: Colors.white),)),
          ],
        ),
      ),
    );
  }
}