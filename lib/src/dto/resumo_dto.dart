import 'package:controle_financeiro/src/utils/utils.dart';
import 'package:intl/intl.dart';

class ResumoDTO{
  ResumoDTO ({
    required this.saldoEmConta,
    required this.totalDespesasMes,
    required this.totalReceitasMes,
    required this.mesSelecionado,
    required this.anoSelecionado,
});

  final double saldoEmConta;
  final double totalDespesasMes;
  final double totalReceitasMes;

  final int mesSelecionado;
  final int anoSelecionado;

  String getMesAnoFormatado(){
    var dataAux = new DateTime(anoSelecionado, mesSelecionado, 1);
    String strMes = Utils.capitalize(DateFormat("MMMM", "pt_BR").format(dataAux));
    return '$strMes/$anoSelecionado';
  }

  List<int> retornarMesAnoAnterior(){
    var dataAux = new DateTime(anoSelecionado, mesSelecionado-1, 1);
    var mes = int.parse(DateFormat('M', "pt_BR").format(dataAux));
    var ano = int.parse(DateFormat('yyyy', "pt_BR").format(dataAux));
    return [mes, ano];
  }

  List<int> retornarMesAnoPosterior(){
    var dataAux = new DateTime(anoSelecionado, mesSelecionado+1, 1);
    var mes = int.parse(DateFormat('M', "pt_BR").format(dataAux));
    var ano = int.parse(DateFormat('yyyy', "pt_BR").format(dataAux));
    return [mes, ano];
  }

  List<int> retornarMesAnoAtual(){
    var mes = int.parse(DateFormat('M', "pt_BR").format(DateTime.now()));
    var ano = int.parse(DateFormat('yyyy', "pt_BR").format(DateTime.now()));
    return [mes, ano];
  }
}