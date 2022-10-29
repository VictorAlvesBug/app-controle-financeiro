import 'package:controle_financeiro/dto/transacao_dto.dart';

class TransacoesDiaDTO {
  TransacoesDiaDTO({
    required this.listaTransacoes,
    required this.data,
  });

  final List<TransacaoDTO> listaTransacoes;
  final DateTime data;

  static List<TransacoesDiaDTO> convertFrom(
      List<TransacaoDTO> listaTransacoes) {
    listaTransacoes.sort((tranA, tranB) {
      return (tranA.data.isBefore(tranB.data)) ? 1 : -1;
    });

    List<TransacoesDiaDTO> listaTransacoesDia =
        listaTransacoes.fold([], (transacoesDia, transacao) {
      bool diaJaAdicionado = transacoesDia.any((transacaoDia) {
        return transacaoDia.data == transacao.data;
      });

      /*bool diaJaAdicionado = transacoesDia.any((transacaoDia) {
        return transacaoDia.listaTransacoes.any((item) {
          return item.data == transacao.data;
        });
      });*/

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
