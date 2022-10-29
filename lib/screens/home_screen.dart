import 'package:controle_financeiro/components/resumo_box.dart';
import 'package:flutter/material.dart';

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
  List<TransacaoDTO> listaTransacoes = [
    TransacaoDTO(
        tipo: TipoTransacaoEnum.Receita,
        valor: 4321,
        data: DateTime(2022, 9, 20),
        descricao: 'Salário Mensal'),
    TransacaoDTO(
        tipo: TipoTransacaoEnum.Despesa,
        valor: 123,
        data: DateTime(2022, 10, 16),
        descricao: 'Conta de Água'),
    TransacaoDTO(
        tipo: TipoTransacaoEnum.Receita,
        valor: 45.84,
        data: DateTime(2022, 9, 24),
        descricao: 'Cashbask Amazon'),
    TransacaoDTO(
        tipo: TipoTransacaoEnum.Despesa,
        valor: 99.99,
        data: DateTime(2022, 9, 24),
        descricao: 'Mensalidade da Academia'),
  ];

  @override
  Widget build(BuildContext context) {

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
      mes: 10,
      ano: 2022,
      saldoEmConta: saldoEmConta,
      totalDespesasMes: totalDespesasMes,
      totalReceitasMes: totalReceitasMes,
    );

    List<TransacoesDiaDTO> listaTransacoesDia =
        TransacoesDiaDTO.convertFrom(listaTransacoes);

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
                itemBuilder: (_, indiceTransacoesDia) {
                  final transacoesDia = listaTransacoesDia[indiceTransacoesDia];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
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
                                      child: Icon(Icons.monetization_on_outlined),
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
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            Utils.formatarData_ddMMyyyy(transacao.data),
                                            style: TextStyle(
                                                color: Colors.white70, fontSize: 12),
                                          ),
                                          SizedBox(height: 5),
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
                    ),
                  );
                },
                separatorBuilder: (_, index) => SizedBox(height: 5),
                itemCount: listaTransacoesDia.length,
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
