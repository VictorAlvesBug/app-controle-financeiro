import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils{
  static void Message(BuildContext context, String text){
    var snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}