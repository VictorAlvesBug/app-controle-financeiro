import 'dart:io';

import 'package:controle_financeiro/src/components/resumo_box.dart';
import 'package:controle_financeiro/src/controllers/transacao_controller.dart';
import 'package:controle_financeiro/src/services/api_service.dart';
import 'package:controle_financeiro/src/services/login_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../dto/resumo_dto.dart';
import '../dto/transacao_dto.dart';
import '../dto/transacoes_dia_dto.dart';
import '../enums/tipo_transacao_enum.dart';
import '../utils/utils.dart';
import 'login_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TransacaoDTO> listaTransacoes = [];
  String nomeUsuario = '';
  bool fabAberto = false;

  @override
  void initState() {
    super.initState();
    HttpOverrides.global = MyHttpOverrides();
    _atualizarTela();
    retornarNomeUsuario();
  }

  @override
  Widget build(BuildContext context) {
    final totalDespesasMes = listaTransacoes.fold(0.0, (acc, transacao) {
      if (transacao.tipo == TipoTransacaoEnum.Despesa) {
        return acc + transacao.valor;
      }

      return acc;
    });

    final totalReceitasMes = listaTransacoes.fold(0.0, (acc, transacao) {
      if (transacao.tipo == TipoTransacaoEnum.Receita) {
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
        TransacoesDiaDTO.getListaTransacoesMes(listaTransacoes,
            mes: resumoDto.mes, ano: resumoDto.ano);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle Financeiro'),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF444444),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Olá, $nomeUsuario',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        InkWell(
                          child: Icon(Icons.logout, color: Colors.white70),
                          onTap: () async {
                            await LoginService().logout();
                            Navigator.pushReplacementNamed(
                                context, LoginScreen.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ResumoBox(
                    resumoDto: resumoDto,
                    callbackAtualizacaoCascata: (resumoDtoCallback) {
                      resumoDto = resumoDtoCallback;
                      setState(() {});
                    }),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListView.separated(
                  itemBuilder: (_, indiceTransacoesDia) {
                    final transacoesDia =
                        listaTransacoesDia[indiceTransacoesDia];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Utils.formatarData_EEEEdd(transacoesDia.data),
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16)),
                        SizedBox(height: 5),
                        ListView.separated(
                          itemBuilder: (_, indiceTransacao) {
                            final transacao =
                                transacoesDia.listaTransacoes[indiceTransacao];

                            return ListTile(
                              tileColor: const Color(0xFF444444),
                              leading: Container(
                                width: 40,
                                height: 40,
                                child: Icon(Icons.monetization_on_outlined,
                                    color: Colors.white70),
                                decoration: BoxDecoration(
                                  color: transacao.getCorTipoTransacao(),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              trailing: InkWell(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white70,
                                ),
                                onTap: () => _modalExcluir(transacao),
                              ),
                              onTap: () => TransacaoController()
                                  .editar(context, transacao.codigo),
                              onLongPress: () => _modalExcluir(transacao),
                              title: Text(
                                transacao.descricao,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                Utils.formatarValor(transacao.valor),
                                style: TextStyle(
                                  color: transacao.getCorTipoTransacao(),
                                  fontSize: 16,
                                ),
                              ),
                              dense: true,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
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
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Theme.of(context).primaryColor,
        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        spacing: 10,
        spaceBetweenChildren: 10,
        children: [
          SpeedDialChild(
            child: Icon(Icons.arrow_upward, color: Colors.white70),
            backgroundColor: Colors.green,
            label: 'Adicionar receita',
            labelBackgroundColor: Color(0xFF333333),
            labelStyle: TextStyle(color: Colors.white70),
            onTap: () {
              TransacaoController()
                  .cadastrar(context, TipoTransacaoEnum.Receita);
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.arrow_downward, color: Colors.white70),
            backgroundColor: Colors.deepOrange,
            label: 'Adicionar despesa',
            labelBackgroundColor: Color(0xFF333333),
            labelStyle: TextStyle(color: Colors.white70),
            onTap: () {
              TransacaoController()
                  .cadastrar(context, TipoTransacaoEnum.Despesa);
            },
          ),
        ],
      ),
    );
  }

  void _modalExcluir(TransacaoDTO transacao) {
    Utils.exibirModalConfirmacao(
      context: context,
      tituloModal: "Excluir Transação",
      textoModal:
          "Deseja mesmo excluir a ${transacao.tipo.name.toLowerCase()} '${transacao.descricao}'?",
      callbackSim: () async {
        ApiService.deletar(transacao.codigo).then((mensagem) {
          Utils.message(context, mensagem);
          setState(() {});
        });
      },
    );
  }

  void retornarNomeUsuario() async {
    nomeUsuario = await LoginService().retornarFirstName();
    setState(() {});
  }

  Future<void> _atualizarTela() async {
    TransacaoController().retornarTransacoes(context).then((lista) {
      listaTransacoes = lista;
      setState(() {});
    });
    return;
  }
}
