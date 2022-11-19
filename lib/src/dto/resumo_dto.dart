import 'package:controle_financeiro/src/utils/utils.dart';
import 'package:intl/intl.dart';

class ResumoDTO{
  ResumoDTO ({
    required this.saldoEmConta,
    required this.totalDespesasMes,
    required this.totalReceitasMes
});

  int mes = int.parse(DateFormat('M', "pt_BR").format(DateTime.now()));
  int ano = int.parse(DateFormat('yyyy', "pt_BR").format(DateTime.now()));

  final double saldoEmConta;
  final double totalDespesasMes;
  final double totalReceitasMes;

  String getMesAnoFormatado(){
    var dataAux = new DateTime(ano, mes, 1);
    String strMes = Utils.capitalize(DateFormat("MMMM", "pt_BR").format(dataAux));
    return '$strMes/$ano';
  }

  void acessarMesAnterior(){
    var dataAux = new DateTime(ano, mes-1, 1);
    ano = int.parse(DateFormat('yyyy', "pt_BR").format(dataAux));
    mes = int.parse(DateFormat('M', "pt_BR").format(dataAux));
  }

  void acessarMesPosterior(){
    var dataAux = new DateTime(ano, mes+1, 1);
    ano = int.parse(DateFormat('yyyy', "pt_BR").format(dataAux));
    mes = int.parse(DateFormat('M', "pt_BR").format(dataAux));
  }
}