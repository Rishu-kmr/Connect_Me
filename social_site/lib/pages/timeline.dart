

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialsite/widgets/header.dart';
import 'package:socialsite/widgets/progress.dart';

final userRef = Firestore.instance.collection('users');

final String id = "K95HUZb1tNcjfbVHoFDw";
class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    getUsers();
//    getUserById();
    getUserAsync();
  }

  getUserAsync() async{
    final QuerySnapshot snapshot = await userRef.getDocuments();
    snapshot.documents.forEach((doc) {
      print(doc.data);
    });
  }
  getUsers(){
    userRef.getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((doc) {
        print(doc.data);
      });
    });
  }

  getUserById(){
    userRef.document(id).get().then((DocumentSnapshot documentSnapshot){
      print(documentSnapshot.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,isAppTitle: true),
      body: Column(
        children: <Widget>[
          Text("hasdf;l"),
          LinearProgress(),
        ],
      ),
    );
  }
}
