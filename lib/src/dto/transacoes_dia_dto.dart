import 'package:controle_financeiro/src/dto/transacao_dto.dart';

class TransacoesDiaDTO {
  TransacoesDiaDTO({
    required this.listaTransacoes,
    required this.data,
  });

  final List<TransacaoDTO> listaTransacoes;
  final DateTime data;

  static List<TransacoesDiaDTO> getListaTransacoesMes(
    List<TransacaoDTO> listaTransacoes, {
    required int mes,
    required int ano,
  }) {

    listaTransacoes = listaTransacoes.where((transacao) =>
      transacao.getMes() == mes && transacao.getAno() == ano).toList();

    listaTransacoes.sort((tranA, tranB) {
      return (tranA.data.isBefore(tranB.data)) ? 1 : -1;
    });

    List<TransacoesDiaDTO> listaTransacoesDia =
        listaTransacoes.fold([], (transacoesDia, transacao) {
      bool diaJaAdicionado = transacoesDia.any((transacaoDia) {
        return transacaoDia.data == transacao.data;
      });

      if (diaJaAdicionado) {
        transacoesDia
            .firstWhere((transacaoDia) {
              return transacaoDia.data == transacao.data;
            })
            .listaTransacoes
            .add(transacao);
      } else {
        transacoesDia.add(TransacoesDiaDTO(
            listaTransacoes: [transacao], data: transacao.data));
      }

      return transacoesDia;
    });

    return listaTransacoesDia;
  }
}
