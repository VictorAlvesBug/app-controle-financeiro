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
    return int.parse(DateFormat('M', "pt_BR").format(data));
  }

  int getAno (){
    return int.parse(DateFormat('yyyy', "pt_BR").format(data));
  }
}