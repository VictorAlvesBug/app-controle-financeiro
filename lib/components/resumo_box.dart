import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../dto/resumo_dto.dart';
import '../utils/utils.dart';

class ResumoBox extends StatelessWidget {

  const ResumoBox({
    Key? key,
    required this.resumoDto,
  }) : super(key: key);

  final ResumoDTO resumoDto;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF444444),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(onTap: () { }, child: Icon(Icons.keyboard_arrow_left, color: Colors.white70,)),
                Text(
                  resumoDto.getMesAnoFormatado(),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                InkWell(onTap: () { }, child: Icon(Icons.keyboard_arrow_right, color: Colors.white70,)),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Saldo em conta',
              style: TextStyle(
                color: Color(0xFFA3A3A3),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              Utils.formatarValor(resumoDto.saldoEmConta),
              style: TextStyle(
                color: Colors.white70,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.arrow_upward),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Receitas',
                          style: TextStyle(
                            color: Color(0xFFA3A3A3),
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          Utils.formatarValor(resumoDto.totalReceitasMes),
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.arrow_downward),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Despesas',
                          style: TextStyle(
                            color: Color(0xFFA3A3A3),
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          Utils.formatarValor(resumoDto.totalDespesasMes),
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
