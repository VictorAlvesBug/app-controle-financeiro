import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static void message(BuildContext context, String text) {
    var snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static exibirModalConfirmacao({
    required BuildContext context,
    required String tituloModal,
    required String textoModal,
    void Function()? callbackSim,
    String textoBotaoSim = "Sim",
    void Function()? callbackNao,
    String textoBotaoNao = "Não",
  }) {
    Widget botaoSim = InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(textoBotaoSim, style: TextStyle(color: Colors.white70)),
      ),
      onTap: () {
        if(callbackSim != null){
          callbackSim();
        }
        Navigator.of(context).pop();
      },
    );

    Widget botaoNao = InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(textoBotaoNao, style: TextStyle(color: Colors.white70)),
      ),
      onTap: () {
        if(callbackNao != null){
          callbackNao();
        }
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xFF444444),
      title: Text(tituloModal, style: TextStyle(color: Colors.white70)),
      content: Text(textoModal, style: TextStyle(color: Colors.white70)),
      actions: [
        botaoSim,
        botaoNao,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
    return DateFormat("dd'/'MM'/'yyyy", "pt_BR").format(data);
  }

  static String formatarData_yyyyMMdd(DateTime data) {
    return DateFormat("yyyy'-'MM'-'dd", "pt_BR").format(data);
  }

  static String formatarData_EEEEdd(DateTime data) {
    String diaSemana = DateFormat('EEEE', "pt_BR").format(data);
    String diaNumerico = DateFormat('dd', "pt_BR").format(data);

    String diaSemanaSemFeira = diaSemana.split('-').elementAt(0);

    String diaSemanaCapitalizado = capitalize(diaSemanaSemFeira);

    return '$diaSemanaCapitalizado, $diaNumerico';
  }

  static capitalize(String texto){
    if(texto.length == 0)
      return "";

    String primeiraLetra = texto[0].toUpperCase();

    if(texto.length == 1)
      return primeiraLetra;

    String demaisLetras = texto.substring(1).toLowerCase();

    return '${primeiraLetra}${demaisLetras}';
  }
}
