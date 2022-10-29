import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../enums/tipo_transacao_enum.dart';

class TransacaoDTO {
  TransacaoDTO({
    required this.tipo,
    required this.valor,
    required this.data,
    required this.descricao,
});

  final TipoTransacaoEnum tipo;
  final double valor;
  final DateTime data;
  final String descricao;

  String getValorFormatado({bool comSinal: false}){
    var formatoReal = new NumberFormat("R\$#,##0.00", "pt_BR");

    if(comSinal && tipo == TipoTransacaoEnum.Despesa){
      return '- ${formatoReal.format(valor)}';
    }
    return formatoReal.format(valor);
  }

  String getDescricaoResumida({int maxLength = 0}){
    var larguraDescricao = descricao.length;

    if(maxLength == 0){
      maxLength = larguraDescricao;
    }

    if(larguraDescricao > maxLength){
      return '${descricao.substring(0, maxLength-3)}...';
    }

    return descricao;
  }

  String getDataFormatada(){
    String dia = DateFormat.d().format(data).padLeft(2, '0');
    String mes = DateFormat.M().format(data).padLeft(2, '0');
    String ano = DateFormat.y().format(data).padLeft(4, '0');

    return '$dia/$mes/$ano';
  }

  Color getCorTipoTransacao(){
    if(tipo == TipoTransacaoEnum.Receita){
      return Colors.green;
    }

    return Colors.deepOrange;
  }
}