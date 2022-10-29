import 'package:controle_financeiro/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ResumoDTO{
  ResumoDTO ({
    required this.saldoEmConta,
    required this.totalDespesasMes,
    required this.totalReceitasMes
});

  int mes = int.parse(DateFormat.M().format(DateTime.now()));
  int ano = int.parse(DateFormat.y().format(DateTime.now()));

  final double saldoEmConta;
  final double totalDespesasMes;
  final double totalReceitasMes;

  String getMesAnoFormatado(){
    var dataAux = new DateTime(ano, mes, 1);
    String strMes = DateFormat.MMMM().format(dataAux).padLeft(2, '0');
    return '$strMes/$ano';
  }

  void acessarMesAnterior(){
    var dataAux = new DateTime(ano, mes-1, 1);
    ano = int.parse(DateFormat.y().format(dataAux));
    mes = int.parse(DateFormat.M().format(dataAux));
  }

  void acessarMesPosterior(){
    var dataAux = new DateTime(ano, mes+1, 1);
    ano = int.parse(DateFormat.y().format(dataAux));
    mes = int.parse(DateFormat.M().format(dataAux));
  }
}