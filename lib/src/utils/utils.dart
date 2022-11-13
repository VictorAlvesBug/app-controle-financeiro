import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static void message(BuildContext context, String text) {
    var snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static String formatarValor(double valor) {
    var formatoReal = new NumberFormat("R\$#,##0.00", "pt_BR");
    return formatoReal.format(valor);
  }

  static String aplicarMascara(String strValor) {
    strValor = strValor.replaceAllMapped(RegExp(r'\D'), (m) => '');
    //Define a largura minima do número em 3 caracteres
    strValor = strValor.replaceAllMapped(RegExp(r'^$'), (m) => '000');
    strValor = strValor.replaceAllMapped(RegExp(r'^(\d)$'), (m) => '00${m[1]}');
    strValor =
        strValor.replaceAllMapped(RegExp(r'^(\d{2})$'), (m) => '0${m[1]}');
    strValor =
        strValor.replaceAllMapped(RegExp(r'^(0+?)(\d)$'), (m) => '00${m[2]}');
    strValor =
        strValor.replaceAllMapped(RegExp(r'^(0+?)(\d{2})$'), (m) => '0${m[2]}');
    strValor =
        strValor.replaceAllMapped(RegExp(r'^(0+?)(\d{3,})$'), (m) => '${m[2]}');

    double valor = double.parse(strValor) / 100;
    //Aplica a máscara de dinheiro
    strValor = strValor.replaceAllMapped(
        RegExp(r'^(\d{1,})(\d{2})$'), (m) => 'R\$ ${m[1]},${m[2]}');
    strValor = strValor.replaceAllMapped(
        RegExp(r'(\d{1,3})(\d{3}\,)'), (m) => '${m[1]}.${m[2]}');
    strValor = strValor.replaceAllMapped(
        RegExp(r'(\d{1,3})(\d{3}\.)'), (m) => '${m[1]}.${m[2]}');
    strValor = strValor.replaceAllMapped(
        RegExp(r'(\d{1,3})(\d{3}\.)'), (m) => '${m[1]}.${m[2]}');
    strValor = strValor.replaceAllMapped(
        RegExp(r'(\d{1,3})(\d{3}\.)'), (m) => '${m[1]}.${m[2]}');

    return strValor;
  }

  static double retornarValor(String strValor) {
    strValor = strValor.replaceAllMapped(RegExp(r'\D'), (m) => '');
    //Define a largura minima do número em 3 caracteres
    strValor = strValor.replaceAllMapped(RegExp(r'^$'), (m) => '000');
    strValor = strValor.replaceAllMapped(RegExp(r'^(\d)$'), (m) => '00${m[1]}');
    strValor =
        strValor.replaceAllMapped(RegExp(r'^(\d{2})$'), (m) => '0${m[1]}');
    strValor =
        strValor.replaceAllMapped(RegExp(r'^(0+?)(\d)$'), (m) => '00${m[2]}');
    strValor =
        strValor.replaceAllMapped(RegExp(r'^(0+?)(\d{2})$'), (m) => '0${m[2]}');
    strValor =
        strValor.replaceAllMapped(RegExp(r'^(0+?)(\d{3,})$'), (m) => '${m[2]}');

    return double.parse(strValor) / 100;
  }

  static String formatarData_ddMMyyyy(DateTime data) {
    String dia = DateFormat.d().format(data).padLeft(2, '0');
    String mes = DateFormat.M().format(data).padLeft(2, '0');
    String ano = DateFormat.y().format(data).padLeft(4, '0');

    return '$dia/$mes/$ano';
  }

  static String formatarData_yyyyMMdd(DateTime data) {
    String dia = DateFormat.d().format(data).padLeft(2, '0');
    String mes = DateFormat.M().format(data).padLeft(2, '0');
    String ano = DateFormat.y().format(data).padLeft(4, '0');

    return '$ano-$mes-$dia';
  }

  static String formatarData_EEEEdd(DateTime data) {
    String diaNumerico = DateFormat.d().format(data).padLeft(2, '0');
    String diaSemana = DateFormat.EEEE().format(data);

    return '$diaSemana, $diaNumerico';
  }
}
