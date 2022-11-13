import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../enums/tipo_transacao_enum.dart';

class TransacaoDTO {
  TransacaoDTO({
    this.codigo,
    required this.tipo,
    required this.valor,
    required this.data,
    required this.descricao,
    this.dataHoraCadastro,
});

  final String? codigo;
  final TipoTransacaoEnum tipo;
  final double valor;
  final DateTime data;
  final String descricao;
  final DateTime? dataHoraCadastro;

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

  Color getCorTipoTransacao(){
    if(ehReceita()){
      return Colors.green;
    }

    return Colors.deepOrange;
  }

  bool ehReceita(){
    return tipo == TipoTransacaoEnum.Receita;
  }

  int getMes (){
    return int.parse(DateFormat.M().format(data));
  }

  int getAno (){
    return int.parse(DateFormat.y().format(data));
  }
}