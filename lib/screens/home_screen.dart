import 'package:controle_financeiro/components/resumo_box.dart';
import 'package:flutter/material.dart';

import '../dto/resumo_dto.dart';
import '../dto/transacao_dto.dart';
import '../enums/tipo_transacao_enum.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var resumoDto = ResumoDTO(
    mes: 'Outubro',
    saldoEmConta: 1234.56,
    totalDespesasMes: 2320.12,
    totalReceitasMes: 4321,
  );

  var listaTransacoes = [
    TransacaoDTO(
        tipo: TipoTransacaoEnum.Receita,
        valor: 4321,
        data: DateTime(2022, 5, 8),
        descricao: 'Salário Mensal'),
    TransacaoDTO(
        tipo: TipoTransacaoEnum.Despesa,
        valor: 123,
        data: DateTime(2022, 5, 8),
        descricao: 'Conta de Água'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              ResumoBox(resumoDto: resumoDto),
              SizedBox(height: 5),
              ListView.separated(
                itemBuilder: (_, index) {
                  final transacao = listaTransacoes[index];

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
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: transacao.getCorTipoTransacao(),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          Text(
                            transacao.getDescricaoResumida(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xFFA3A3A3),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                transacao.getDataFormatada(),
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                              SizedBox(height: 5),
                              Text(
                                transacao.getValorFormatado(comSinal: true),
                                style: TextStyle(
                                  color: transacao.getCorTipoTransacao(),
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => SizedBox(height: 5),
                itemCount: listaTransacoes.length,
                shrinkWrap: true,
              ),

              /*ListView(
              children: [],
                scrollDirection: Axis.vertical,
              ),*/
            ],
          ),
        ),
      ),
      /*body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Adicionar',
        child: const Icon(Icons.add),
      ),
    );
  }
}
