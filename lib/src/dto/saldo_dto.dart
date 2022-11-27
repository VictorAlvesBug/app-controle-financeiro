import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../enums/tipo_transacao_enum.dart';

class SaldoDTO {
  SaldoDTO({
    this.totalReceitas = 0.0,
    this.totalDespesas = 0.0,
    this.saldoTotal = 0.0,
});

  final double totalReceitas;
  final double totalDespesas;
  final double saldoTotal;
}