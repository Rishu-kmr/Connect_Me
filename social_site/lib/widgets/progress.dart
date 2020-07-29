import 'package:flutter/material.dart';

Widget CircularProgress(){
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 20.0),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.purple),
    ),
  );
}

Widget LinearProgress(){
  return Container(
    padding: EdgeInsets.only(bottom: 20.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.purple),
    ),
  );
}