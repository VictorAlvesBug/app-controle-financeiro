import 'package:intl/intl.dart';

class ResumoDTO{
  ResumoDTO ({
    required this.mes,
    required this.ano,
    required this.saldoEmConta,
    required this.totalDespesasMes,
    required this.totalReceitasMes
});

  final int mes;
  final int ano;
  final double saldoEmConta;
  final double totalDespesasMes;
  final double totalReceitasMes;

  String getMesAnoFormatado(){
    var dataAux = new DateTime(ano, mes, 1);
    String strMes = DateFormat.MMMM().format(dataAux).padLeft(2, '0');
    return '$strMes/$ano';
  }
}