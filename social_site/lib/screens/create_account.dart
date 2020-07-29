import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socialsite/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String username;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  submit(){
    final form = _formKey.currentState;

    if(form.validate()){
      form.save();
      SnackBar snackBar = SnackBar(content: Text("Welcome $username!",style: TextStyle(fontSize: 28.0),));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 1),(){
      Navigator.pop(context,username);
      });

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context,appTitle: "create a username",removeBackButton: true),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text(
                'Set up a User Name',
                style: TextStyle(
                  fontSize: 36.0,
                  fontFamily: "Signatra",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25.0),
              child: Container(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    autovalidate: true,
                    validator: (val){
                      if(val.trim().length<3 || val.isEmpty){
                        return "username too short";
                      }
                      else if(val.trim().length>12){
                        return "username too long";
                      }
                      return null;
                    },
                    onSaved: (val){
                      username = val;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "More than 3 characters",
                      labelText: "username",
                      labelStyle: TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: submit,
              child: Container(
                height: 50.0,
                width: 300.0,
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
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
