import 'dart:html';
import 'dart:io';
import 'dart:math';

import 'package:controle_financeiro/src/components/my_text_field.dart';
import 'package:controle_financeiro/src/components/resumo_box.dart';
import 'package:controle_financeiro/src/services/api_service.dart';
import 'package:controle_financeiro/src/services/login_service.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
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

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    HttpOverrides.global = MyHttpOverrides();
    fetchTransacoes();
    retornarNomeUsuario();
  }

  String descricao = "";
  double valor = 0;
  DateTime dataTransacao = DateTime.now();
  TipoTransacaoEnum tipo = TipoTransacaoEnum.Despesa;

  TextEditingController dataTransacaoController = TextEditingController();

  Future<void> _abrirModalCadastroTransacao(
      BuildContext context, TipoTransacaoEnum tipoTransacao) async {
    final CurrencyTextInputFormatter _formatadorDinheiro =
        CurrencyTextInputFormatter(
            locale: 'pt-br', decimalDigits: 2, symbol: "R\$");

    tipo = tipoTransacao;

    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(minWidth: 250, maxWidth: 500, minHeight: 250, maxHeight: 500,),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFF444444)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Adicionar ${tipoTransacao.name}',
                            style: TextStyle(color: Colors.white70, fontSize: 20)),
                        SizedBox(height: 20),
                        MyTextField(
                          validator: _validadorDescricao,
                          onChanged: (value) {
                            descricao = value;
                          },
                          labelText: "Descrição",
                          iconData: Icons.message,
                        ),
                        MyTextField(
                          validator: _validadorValor,
                          onChanged: (value) {
                            valor = Utils.retornarValor(value);
                          },
                          labelText: "Valor",
                          iconData: Icons.monetization_on_outlined,
                          inputFormatters: [_formatadorDinheiro],
                          keyboardType: TextInputType.number,
                        ),
                        MyTextField(
                          labelText: "Data",
                          controller: dataTransacaoController,
                          iconData: Icons.calendar_today,
                          onTap: () async {
                            await _abrirDatePicker();
                          },
                          onChanged: (value) async {
                            await _abrirDatePicker();
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          child: const Text('Salvar'),
                          onPressed: _cadastrarTransacao,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  String? _validadorDescricao(String? value) {
    String descricao = value ?? "";

    if (descricao.trim().isEmpty) {
      return "Informe uma descrição";
    }

    return null;
  }

  String? _validadorValor(String? value) {
    String strValor = value ?? "";

    double valor = Utils.retornarValor(strValor);

    if (valor <= 0) {
      return "Informe uma valor válido";
    }

    return null;
  }

  Future<void> _abrirDatePicker() async {
    DateTime date = DateTime(1900);
    FocusScope.of(context).requestFocus(new FocusNode());

    dataTransacao = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        ) ??
        DateTime.now();

    dataTransacaoController.text = Utils.formatarData_ddMMyyyy(dataTransacao);
  }

  void _cadastrarTransacao() async {
    bool valido = _formKey.currentState?.validate() ?? false;

    if (!valido) {
      return;
    }
    TransacaoDTO transacao = TransacaoDTO(
      tipo: tipo,
      valor: valor,
      data: dataTransacao,
      descricao: descricao,
    );
    String mensagem = await ApiService().cadastrarTransacao(transacao);

    Utils.message(context, mensagem);
    Navigator.pop(context);
    setState(() {});
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

                            return Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF444444),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      child: Icon(
                                          Icons.monetization_on_outlined,
                                          color: Colors.white70),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            Utils.formatarValor(
                                                transacao.valor),
                                            style: TextStyle(
                                              color: transacao
                                                  .getCorTipoTransacao(),
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
        initialOpen: fabAberto,
        children: [
          ActionButton(
            onPressed: () => _abrirModalCadastroTransacao(
                context, TipoTransacaoEnum.Receita),
            color: Colors.green,
            label: 'Receita',
            icon: const Icon(Icons.arrow_upward),
          ),
          ActionButton(
            onPressed: () => _abrirModalCadastroTransacao(
                context, TipoTransacaoEnum.Despesa),
            color: Colors.deepOrange,
            label: 'Despesa',
            icon: const Icon(Icons.arrow_downward),
          ),
        ],
      ),
    );
  }

  void fetchTransacoes() async {
    try {
      listaTransacoes = await ApiService().retornarTransacoes();
      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  void retornarNomeUsuario() async {
    nomeUsuario = await LoginService().retornarFirstName();
    setState(() {});
  }
}
