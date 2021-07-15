import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:khodnyfesektk/Services/shared.dart';

class Navbar extends StatefulWidget {
  const Navbar({ Key? key }) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      items: [
        TabItem(icon: Icons.home, title: 'الرئيسية'),
        TabItem(icon: Icons.star, title: 'التقييمات'),
        TabItem(icon: Icons.add, title: 'اضافة'),
        TabItem(icon: Icons.message, title: 'اتصل بنا'),
        TabItem(icon: Icons.person, title: 'البروفايل'),
      ],
      elevation: 0,
      style: TabStyle.fixedCircle,
      backgroundColor: Colors.yellow,
      color: Colors.black,
      activeColor: Colors.black,
      onTap: (int i){
        switch (i){
          case 0:
          if(ModalRoute.of(context)!.settings.name != "/home")
          Navigator.of(context).pushNamed('/home');
          break;
          case 1:
          if(ModalRoute.of(context)!.settings.name != "/ratings")
          Navigator.of(context).pushNamed('/ratings');
          break;
          case 2:
          if(ModalRoute.of(context)!.settings.name != "/add")
          Navigator.of(context).pushNamed('/add');
          break;
          case 3:
          if(ModalRoute.of(context)!.settings.name != "/contact")
          Navigator.of(context).pushNamed('/contact');
          break;
          case 4:
          if(ModalRoute.of(context)!.settings.name != "/profile")
          Navigator.of(context).pushNamed('/profile');
          break;
        }
      }
    );
  }
}