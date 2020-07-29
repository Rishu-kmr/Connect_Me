import 'package:flutter/material.dart';

Widget header(BuildContext context,{bool isAppTitle = false, String appTitle,removeBackButton = false}){
  return AppBar(
    automaticallyImplyLeading: removeBackButton? false: true,
    title: Text(
        isAppTitle? "FlutterShare": appTitle,
      style: TextStyle(
        fontFamily: isAppTitle? "Signatra":"",
        fontSize: isAppTitle? 45.0 : 24.0,
      ),
    ),
    centerTitle: true,
  );
}