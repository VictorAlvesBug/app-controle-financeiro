import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../dto/resumo_dto.dart';
import '../utils/utils.dart';
import 'my_count_up.dart';

class ResumoBox extends StatefulWidget {
  ResumoBox({
    Key? key,
    required this.resumoDto,
    this.callbackAtualizacaoCascata,
  }) : super(key: key);

  final ResumoDTO resumoDto;
  var callbackAtualizacaoCascata;

  @override
  State<ResumoBox> createState() => _ResumoBoxState();
}

class _ResumoBoxState extends State<ResumoBox> {
  int mesExibindo = int.parse(DateFormat('M', "pt_BR").format(DateTime.now()));
  int anoExibindo =
      int.parse(DateFormat('yyyy', "pt_BR").format(DateTime.now()));

  @override
  Widget build(BuildContext context) {
    final dataAtual = DateTime.now();
    final strMesAtual =
        Utils.capitalize(DateFormat("MMMM", "pt_BR").format(dataAtual));
    final anoAtual = DateFormat('yyyy', "pt_BR").format(dataAtual);
    final mesAnoAtualFormatado = '$strMesAtual/$anoAtual';

    bool ehMesAtual = mesExibindo ==
            int.parse(DateFormat('M', "pt_BR").format(DateTime.now())) &&
        anoExibindo ==
            int.parse(DateFormat('yyyy', "pt_BR").format(DateTime.now()));

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF444444),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Stack(
          children: [
            ehMesAtual
                ? SizedBox()
                : Positioned(
                    top: 0,
                    left: 0,
                    child: Center(
                      child: InkWell(
                        child: Container(
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.calendar_today,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                        onTap: () async {
                          var mesAnoAtual =
                              widget.resumoDto.retornarMesAnoAtual();
                          mesExibindo = mesAnoAtual[0];
                          anoExibindo = mesAnoAtual[1];
                          widget.callbackAtualizacaoCascata(
                              mesExibindo, anoExibindo);
                        },
                      ),
                    ),
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {
                          var mesAnoAnterior =
                              widget.resumoDto.retornarMesAnoAnterior();
                          mesExibindo = mesAnoAnterior[0];
                          anoExibindo = mesAnoAnterior[1];
                          widget.callbackAtualizacaoCascata(
                              mesExibindo, anoExibindo);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.keyboard_arrow_left,
                              color: Colors.white70, size: 32),
                        )),
                    Container(
                      width: 160,
                      alignment: Alignment.center,
                      child: Text(
                        widget.resumoDto.getMesAnoFormatado(),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: mesAnoAtualFormatado ==
                                  widget.resumoDto.getMesAnoFormatado()
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          var mesAnoAnterior =
                              widget.resumoDto.retornarMesAnoPosterior();
                          mesExibindo = mesAnoAnterior[0];
                          anoExibindo = mesAnoAnterior[1];
                          widget.callbackAtualizacaoCascata(
                              mesExibindo, anoExibindo);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.keyboard_arrow_right,
                              color: Colors.white70, size: 32),
                        )),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Saldo em conta',
                  style: TextStyle(
                    color: Color(0xFFA3A3A3),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                MyCountUp(
                  begin: 0,
                  end: widget.resumoDto.saldoEmConta,
                  duration: const Duration(seconds: 1),
                  prefix: 'R\$',
                  separator: '.',
                  decimalSeparator: ',',
                  precision: 2,
                  style: const TextStyle(
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
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.arrow_upward,
                              color: Colors.white70),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Receitas',
                                style: TextStyle(
                                  color: Color(0xFFA3A3A3),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              MyCountUp(
                                begin: 0,
                                end: widget.resumoDto.totalReceitasMes,
                                duration: const Duration(seconds: 1),
                                prefix: 'R\$',
                                separator: '.',
                                decimalSeparator: ',',
                                precision: 2,
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.arrow_downward,
                              color: Colors.white70),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Despesas',
                                style: TextStyle(
                                  color: Color(0xFFA3A3A3),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              MyCountUp(
                                begin: 0,
                                end: widget.resumoDto.totalDespesasMes,
                                duration: const Duration(seconds: 1),
                                prefix: 'R\$',
                                separator: '.',
                                decimalSeparator: ',',
                                precision: 2,
                                style: const TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
