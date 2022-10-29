import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils{
  static void message(BuildContext context, String text){
    var snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static String formatarData_ddMMyyyy(DateTime data){
    String dia = DateFormat.d().format(data).padLeft(2, '0');
    String mes = DateFormat.M().format(data).padLeft(2, '0');
    String ano = DateFormat.y().format(data).padLeft(4, '0');

    return '$dia/$mes/$ano';
  }

  static String formatarData_EEEEdd(DateTime data){
    String diaNumerico = DateFormat.d().format(data).padLeft(2, '0');
    String diaSemana = DateFormat.EEEE().format(data);

    return '$diaSemana, $diaNumerico';
  }
}