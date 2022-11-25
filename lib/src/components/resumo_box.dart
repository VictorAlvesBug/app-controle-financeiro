import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../dto/resumo_dto.dart';
import '../utils/utils.dart';

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
  @override
  Widget build(BuildContext context) {
    final dataAtual = DateTime.now();
    final strMesAtual =
        Utils.capitalize(DateFormat("MMMM", "pt_BR").format(dataAtual));
    final anoAtual = DateFormat('yyyy', "pt_BR").format(dataAtual);
    final mesAnoAtualFormatado = '$strMesAtual/$anoAtual';

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
            const SizedBox(height: 10),
            Center(
              child: InkWell(
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.orange,
                  size: 20,
                ),
                onTap: () async {
                  var mesAnoAtual = widget.resumoDto.retornarMesAnoAtual();
                  var mes = mesAnoAtual[0];
                  var ano = mesAnoAtual[1];
                  //setState(() {});
                  widget.callbackAtualizacaoCascata(mes, ano);
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      var mesAnoAnterior =
                          widget.resumoDto.retornarMesAnoAnterior();
                      var mes = mesAnoAnterior[0];
                      var ano = mesAnoAnterior[1];
                      //setState(() {});
                      widget.callbackAtualizacaoCascata(mes, ano);
                    },
                    child: Icon(Icons.keyboard_arrow_left,
                        color: Colors.white70, size: 28)),
                Container(
                  width: 200,
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
                      var mes = mesAnoAnterior[0];
                      var ano = mesAnoAnterior[1];
                      //setState(() {});
                      widget.callbackAtualizacaoCascata(mes, ano);
                    },
                    child: Icon(Icons.keyboard_arrow_right,
                        color: Colors.white70, size: 28)),
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
            Text(
              Utils.formatarValor(widget.resumoDto.saldoEmConta),
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
                      child: Icon(Icons.arrow_upward, color: Colors.white70),
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
                          Utils.formatarValor(
                              widget.resumoDto.totalReceitasMes),
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
                      child: Icon(Icons.arrow_downward, color: Colors.white70),
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
                          Utils.formatarValor(
                              widget.resumoDto.totalDespesasMes),
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
