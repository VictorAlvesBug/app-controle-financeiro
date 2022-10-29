import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../dto/resumo_dto.dart';

class ResumoBox extends StatelessWidget {

  const ResumoBox({
    Key? key,
    required this.resumoDto,
  }) : super(key: key);

  final ResumoDTO resumoDto;

  @override
  Widget build(BuildContext context) {

    final formatoReal = new NumberFormat("R\$#,##0.00", "pt_BR");

    String saldoEmContaFormatado = formatoReal.format(resumoDto.saldoEmConta);
    String totalReceitasMesFormatado = formatoReal.format(resumoDto.totalReceitasMes);
    String totalDespesasMesFormatado = formatoReal.format(resumoDto.totalDespesasMes);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF444444),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Text(
            resumoDto.mes,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Saldo em conta',
            style: TextStyle(
              color: Color(0xFFA3A3A3),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            saldoEmContaFormatado,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'Receitas',
                    style: TextStyle(
                      color: Color(0xFFA3A3A3),
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    totalReceitasMesFormatado,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Despesas',
                    style: TextStyle(
                      color: Color(0xFFA3A3A3),
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    totalDespesasMesFormatado,
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
