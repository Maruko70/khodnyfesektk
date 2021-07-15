import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:khodnyfesektk/Services/shared.dart';
import 'package:khodnyfesektk/consts.dart';

class ChatScreen extends StatefulWidget {
  final String? id;
  const ChatScreen({ Key? key, this.id }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {  
  TextEditingController _msgController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var messages = FirebaseDatabase.instance.reference().child('chats').child(widget.id!);
    return Directionality(textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("دردشة الرحلة", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            StreamBuilder<Event?>(
              stream: messages.onValue,
              builder: (context, snap) {
                        if (snap.hasData &&
                            !snap.hasError &&
                            snap.data!.snapshot.value != null) {
                          Map data = snap.data!.snapshot.value;
                          List<Map> list = [];
                          data.forEach((key, value) {
                            list.add({
                              "name" : value['name'], 
                              "from" : value['from'], 
                              "text" : value['text'], 
                              "date" : value['date'], 
                            });
                          });
                          
                          return ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: list[index]['from'] == sharedPrefs.uid ? Container(
                                  
                                  decoration: BoxDecoration(
                                    boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
   ],
   color: Colors.yellow[100]!,
                                  ),
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(list[index]['name'], style: TextStyle(fontSize: 22)),
                                        Text(list[index]['text'], style: TextStyle(fontSize: 20)),
                                        Text(list[index]['date'], style: TextStyle(fontSize: 10)),
                                      ],
                                    ),
                                  ),
                                ) : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
   ],
                                  ),
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(list[index]['name'], style: TextStyle(fontSize: 22)),
                                        Text(list[index]['text'], style: TextStyle(fontSize: 20)),
                                        Text(list[index]['date'], style: TextStyle(fontSize: 10)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else
                          return Center(child: Text("No data"));
                      },
            ),
            Positioned(
              bottom: 10.0,
              width: size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: kBoxDecorationStyle2,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                    children: <Widget>[
                    Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "ادخل رسالتك",
                        border: InputBorder.none,
                      ),
                      controller: _msgController,
                    ),
          ),
          IconButton(
                    onPressed: (){
                      FirebaseDatabase.instance.reference().child('chats').child(widget.id!).push().set({
                        "from" : FirebaseAuth.instance.currentUser!.uid,
                        "name" : sharedPrefs.name,
                        "text" : _msgController.text.trim(),
                        "date" : "${DateTime.now().year} / ${DateTime.now().month} / ${DateTime.now().day} - ${DateTime.now().hour}:${DateTime.now().minute}",
                      }).then((value){
                        _msgController.clear();
                      });
                    },
                    icon: Icon(Icons.send),
          )
          ],
        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}