import 'dart:html';
import 'dart:math';

import '../components/resumo_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import '../components/action_button.dart';
import '../components/expandable_fab.dart';
import '../dto/resumo_dto.dart';
import '../dto/transacao_dto.dart';
import '../dto/transacoes_dia_dto.dart';
import '../enums/tipo_transacao_enum.dart';
import '../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TransacaoDTO> listaTransacoes = [];
  
  String descricao = "";
  String valor = "";

  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _valorController = TextEditingController();

  Future<void> _displayTextInputDialog(BuildContext context, TipoTransacaoEnum tipoTransacao) async {
   return showDialog(
       context: context,
       builder: (context) {
         return AlertDialog(
           backgroundColor: Color.fromARGB(255, 68, 68, 68),
           title: Text('Adicionar ${tipoTransacao.name}', style: TextStyle(color: Colors.white70)),
           content: Column(
             children: [
               TextField(
                 onChanged: (value) {
                   setState(() {
                     descricao = value;
                   });
                 },
                 controller: _descricaoController,
                 decoration: const InputDecoration(hintText: "Descrição"),
               ),
               TextField(
                 onChanged: (value) {
                   setState(() {
                     valor = value;
                   });
                 },
                 controller: _valorController,
                 decoration: const InputDecoration(hintText: "Valor"),
               ),
             ],
           ),
           actions: <Widget>[
             ElevatedButton(
               /*color: Colors.green,
               textColor: Colors.white,*/
               child: const Text('OK'),
               onPressed: () {
                 setState(() {
                   print('Descrição: $descricao');
                   print('Valor: $valor');
                   Navigator.pop(context);
                 });
               },
             ),
  
           ],
         );
       });
 }

  @override
  Widget build(BuildContext context) {

    for(var i=0; i<5; i++)
      {
        var randomGenerator = Random();

        final tipo = randomGenerator.nextBool() ? TipoTransacaoEnum.Receita : TipoTransacaoEnum.Despesa;

        final valor = randomGenerator.nextDouble() * 500;

        final diaDoMes = randomGenerator.nextInt(28);
        final dataAtual = DateTime.now();
        final mesAtual = int.parse(DateFormat.M().format(dataAtual));
        final anoAtual = int.parse(DateFormat.y().format(dataAtual));
        final data = DateTime(anoAtual, mesAtual, diaDoMes);

        final descricao = '${tipo.name} aleatória #$i';

        listaTransacoes.add(TransacaoDTO(tipo: tipo, valor: valor, data: data, descricao: descricao));

      }

    final totalDespesasMes = listaTransacoes.fold(0.0, (acc, transacao) {
      if(transacao.tipo == TipoTransacaoEnum.Despesa)
        {
          return acc + transacao.valor;
        }

      return acc;
    });

    final totalReceitasMes = listaTransacoes.fold(0.0, (acc, transacao) {
      if(transacao.tipo == TipoTransacaoEnum.Receita)
      {
        return acc + transacao.valor;
      }

      return acc;
    });

    final saldoEmConta = totalReceitasMes - totalDespesasMes;

    ResumoDTO resumoDto = ResumoDTO(
      saldoEmConta: saldoEmConta,
      totalDespesasMes: totalDespesasMes,
      totalReceitasMes: totalReceitasMes,
    );

    List<TransacoesDiaDTO> listaTransacoesDia =
        TransacoesDiaDTO.getListaTransacoesMes(listaTransacoes, mes: resumoDto.mes, ano: resumoDto.ano);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ResumoBox(resumoDto: resumoDto, callbackAtualizacaoCascata: (resumoDtoCallback) {
                  resumoDto = resumoDtoCallback;
                  setState(() {});
                }),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListView.separated(
                  itemBuilder: (_, indiceTransacoesDia) {
                    final transacoesDia = listaTransacoesDia[indiceTransacoesDia];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Utils.formatarData_EEEEdd(transacoesDia.data), style: TextStyle(color: Colors.white70, fontSize: 16)),
                        SizedBox(height: 5),
                        ListView.separated(
                          itemBuilder: (_, indiceTransacao) {
                            final transacao = transacoesDia.listaTransacoes[indiceTransacao];

                            return Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF444444),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      child: Icon(Icons.monetization_on_outlined, color: Colors.white70),
                                      decoration: BoxDecoration(
                                        color: transacao.getCorTipoTransacao(),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      transacao.getDescricaoResumida(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color(0xFFA3A3A3),
                                        fontSize: 18,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                              Utils.formatarValor(transacao.valor),
                                            style: TextStyle(
                                              color: transacao.getCorTipoTransacao(),
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, index) => SizedBox(height: 10),
                          itemCount: transacoesDia.listaTransacoes.length,
                          shrinkWrap: true,
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (_, index) => SizedBox(height: 15),
                  itemCount: listaTransacoesDia.length,
                  shrinkWrap: true,
                ),
              ),

              /*ListView(
              children: [],
                scrollDirection: Axis.vertical,
              ),*/
            ],
          ),
        ),
      ),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () => _displayTextInputDialog(context, TipoTransacaoEnum.Receita),
            color: Colors.green,
            label: 'Receita',
            icon: const Icon(Icons.arrow_upward),
          ),
          ActionButton(
            onPressed: () => _displayTextInputDialog(context, TipoTransacaoEnum.Despesa),
            color: Colors.deepOrange,
            label: 'Despesa',
            icon: const Icon(Icons.arrow_downward),
          ),
        ],
      ),
    );
  }
}
