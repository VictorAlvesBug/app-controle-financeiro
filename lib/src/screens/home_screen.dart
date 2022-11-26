import 'dart:io';

import 'package:controle_financeiro/src/components/resumo_box.dart';
import 'package:controle_financeiro/src/controllers/transacao_controller.dart';
import 'package:controle_financeiro/src/services/login_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:simple_rich_text/simple_rich_text.dart';

import '../dto/resumo_dto.dart';
import '../dto/saldo_dto.dart';
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

  final fabAberto = ValueNotifier(false);

  int mesSelecionado =
      int.parse(DateFormat('M', "pt_BR").format(DateTime.now()));
  int anoSelecionado =
      int.parse(DateFormat('yyyy', "pt_BR").format(DateTime.now()));

  ResumoDTO resumoDto = ResumoDTO(
    saldoEmConta: 0,
    totalDespesasMes: 0,
    totalReceitasMes: 0,
    mesSelecionado: 11,
    anoSelecionado: 2022,
  );

  final _nomeUsuarioNotifier = ValueNotifier<String>("");
  final _loadingNotifier = ValueNotifier<bool>(true);
  final _exibicaoFabNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    HttpOverrides.global = MyHttpOverrides();
    _atualizarTela();
    _retornarNomeUsuario();
  }

  @override
  void dispose() {
    _exibicaoFabNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginService().retornarUserId().then((userId) {
      if (userId == null || userId.isEmpty) {
        Navigator.pushReplacementNamed(context, LoginScreen.id);
      }
    });

    List<TransacoesDiaDTO> listaTransacoesDia =
        TransacoesDiaDTO.getListaTransacoesMes(listaTransacoes,
            mes: resumoDto.mesSelecionado, ano: resumoDto.anoSelecionado);

    const duracaoAnimacaoFab = Duration(milliseconds: 300);

    Widget loadingWidget = const Center(
      child: SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(color: Colors.indigo),
      ),
    );

    Widget listaVaziaWidget = const Center(
      child: Text(
        "Você não possui transações neste mês",
        style: TextStyle(color: Colors.white70),
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        if (fabAberto.value) {
          fabAberto.value = false;
          return false;
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Controle Financeiro'),
        ),
        backgroundColor: Colors.black,
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            final ScrollDirection direction = notification.direction;
            if (direction == ScrollDirection.reverse) {
              _exibicaoFabNotifier.value = false;
            } else if (direction == ScrollDirection.forward) {
              _exibicaoFabNotifier.value = true;
            }
            return true;
          },
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    top: 8,
                    right: 8,
                    bottom: 4,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF444444),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: _nomeUsuarioNotifier,
                            builder: (_, nomeUsuario, __) => Text(
                              'Olá, $nomeUsuario',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                          ),
                          InkWell(
                            child:
                                const Icon(Icons.logout, color: Colors.white70),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ResumoBox(
                      resumoDto: resumoDto,
                      callbackAtualizacaoCascata: (int mes, int ano) {
                        _loadingNotifier.value = true;
                        mesSelecionado = mes;
                        anoSelecionado = ano;
                        _atualizarTela();
                      }),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      top: 4,
                      right: 8,
                      bottom: 4,
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: _loadingNotifier,
                      builder: (_, isLoading, __) => isLoading
                          ? loadingWidget
                          : (listaTransacoesDia.isEmpty
                              ? listaVaziaWidget
                              : ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (_, indiceTransacoesDia) {
                                    final transacoesDia =
                                        listaTransacoesDia[indiceTransacoesDia];

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            Utils.formatarData_EEEEdd(
                                                transacoesDia.data),
                                            style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 16)),
                                        const SizedBox(height: 5),
                                        ListView.separated(
                                          shrinkWrap: true,
                                          itemBuilder: (_, indiceTransacao) {
                                            final transacao =
                                                transacoesDia.listaTransacoes[
                                                    indiceTransacao];

                                            return Expanded(
                                              child: ListTile(
                                                tileColor:
                                                    const Color(0xFF444444),
                                                leading: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: transacao
                                                        .getCorTipoTransacao(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: const Icon(
                                                      Icons
                                                          .monetization_on_outlined,
                                                      color: Colors.white70),
                                                ),
                                                trailing: InkWell(
                                                  child: const Icon(
                                                    Icons.delete,
                                                    color: Colors.white70,
                                                  ),
                                                  onTap: () =>
                                                      _modalExcluir(transacao),
                                                ),
                                                onTap: () {
                                                  TransacaoController()
                                                      .editar(context,
                                                          transacao.codigo)
                                                      .then((_) {
                                                    _atualizarTela();
                                                  });
                                                },
                                                onLongPress: () =>
                                                    _modalExcluir(transacao),
                                                title: Text(
                                                  transacao.descricao,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  Utils.formatarValor(
                                                      transacao.valor),
                                                  style: TextStyle(
                                                    color: transacao
                                                        .getCorTipoTransacao(),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                dense: true,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (_, index) =>
                                              const SizedBox(height: 10),
                                          itemCount: transacoesDia
                                              .listaTransacoes.length,
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (_, index) =>
                                      const SizedBox(height: 15),
                                  itemCount: listaTransacoesDia.length,
                                  shrinkWrap: true,
                                )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: ValueListenableBuilder(
          valueListenable: _exibicaoFabNotifier,
          builder: (_, exibirFab, __) => AnimatedSlide(
            duration: duracaoAnimacaoFab,
            offset: exibirFab ? Offset.zero : const Offset(0, 2),
            child: AnimatedOpacity(
              duration: duracaoAnimacaoFab,
              opacity: exibirFab ? 1 : 0,
              child: SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                backgroundColor: Theme.of(context).primaryColor,
                overlayColor: Colors.black,
                overlayOpacity: 0.4,
                spacing: 10,
                spaceBetweenChildren: 10,
                openCloseDial: fabAberto,
                children: [
                  SpeedDialChild(
                    child:
                        const Icon(Icons.arrow_upward, color: Colors.white70),
                    backgroundColor: Colors.green,
                    label: 'Adicionar receita',
                    labelBackgroundColor: const Color(0xFF333333),
                    labelStyle: const TextStyle(color: Colors.white70),
                    onTap: () {
                      TransacaoController()
                          .cadastrar(context, TipoTransacaoEnum.Receita)
                          .then((_) {
                        _atualizarTela();
                      });
                    },
                  ),
                  SpeedDialChild(
                    child:
                        const Icon(Icons.arrow_downward, color: Colors.white70),
                    backgroundColor: Colors.deepOrange,
                    label: 'Adicionar despesa',
                    labelBackgroundColor: const Color(0xFF333333),
                    labelStyle: const TextStyle(color: Colors.white70),
                    onTap: () {
                      TransacaoController()
                          .cadastrar(context, TipoTransacaoEnum.Despesa)
                          .then((_) {
                        _atualizarTela();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _modalExcluir(TransacaoDTO transacao) {
    String strTipo = transacao.tipo.name.toLowerCase();
    String strValor = Utils.formatarValor(transacao.valor);

    Utils.exibirModalConfirmacao(
      context: context,
      tituloModal: SimpleRichText("Excluir $strTipo",
          style: const TextStyle(color: Colors.white70)),
      textoModal: SimpleRichText(
          'A $strTipo "*${transacao.descricao}*", de *$strValor*, será excluída.',
          style: const TextStyle(color: Colors.white70)),
      textoBotaoSim: "OK",
      textoBotaoNao: "Cancelar",
      callbackSim: () async {
        TransacaoController()
            .deletar(context, transacao.codigo)
            .then((mensagem) {
          Utils.message(context, mensagem);
          _atualizarTela();
        });
      },
    );
  }

  void _retornarNomeUsuario() async {
    _nomeUsuarioNotifier.value = await LoginService().retornarFirstName();
  }

  Future<void> _atualizarTela() async {
    TransacaoController()
        .retornarTransacoes(context, mesSelecionado, anoSelecionado)
        .then((lista) async {
      listaTransacoes = lista;
      resumoDto = await _retornarResumo();
      _loadingNotifier.value = false;
      setState(
          () {}); //Neste caso é necessário, pois o build precisa ser executado novamente para renderizar toda a tela
    });
    return;
  }

  Future<ResumoDTO> _retornarResumo() async {
    SaldoDTO saldoDto = await TransacaoController().retornarSaldo(context);

    double totalDespesasMes = 0;
    double totalReceitasMes = 0;

    Set<TransacaoDTO> setListaTransacoes = Set.from(listaTransacoes);

    for (var transacao in setListaTransacoes) {
      if (transacao.ehReceita()) {
        totalReceitasMes += transacao.valor;
      } else {
        totalDespesasMes += transacao.valor;
      }
    }

    return ResumoDTO(
      saldoEmConta: saldoDto.saldoTotal,
      totalDespesasMes: totalDespesasMes,
      totalReceitasMes: totalReceitasMes,
      mesSelecionado: mesSelecionado,
      anoSelecionado: anoSelecionado,
    );
  }
}
