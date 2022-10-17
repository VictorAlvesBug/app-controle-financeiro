import 'package:flutter/material.dart';

class ResumoBox extends StatelessWidget {

  const ResumoBox({
    Key? key,
    required this.mes,
    required this.saldoEmConta,
    required this.totalReceitasMes,
    required this.totalDespesasMes,
  }) : super(key: key);

  final String mes;
  final double saldoEmConta;
  final double totalReceitasMes;
  final double totalDespesasMes;

  @override
  Widget build(BuildContext context) {
    String saldoEmContaFormatado = saldoEmConta.toString();
    String totalReceitasMesFormatado = totalReceitasMes.toString();
    String totalDespesasMesFormatado = totalDespesasMes.toString();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF444444),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Text(
            mes,
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
