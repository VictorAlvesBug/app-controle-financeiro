import 'package:controle_financeiro/src/components/my_text_field.dart';
import 'package:controle_financeiro/src/dto/transacao_dto.dart';
import 'package:controle_financeiro/src/enums/tipo_transacao_enum.dart';
import 'package:controle_financeiro/src/services/api_service.dart';
import 'package:controle_financeiro/src/utils/utils.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

class TransacaoController {
  final _formKey = GlobalKey<FormState>();

  String codigo = "";
  String descricao = "";
  double valor = 0;
  DateTime dataTransacao = DateTime.now();
  TipoTransacaoEnum tipo = TipoTransacaoEnum.Despesa;

  TextEditingController dataTransacaoController = TextEditingController();

  Future<void> cadastrar(
      BuildContext context, TipoTransacaoEnum tipoTransacao) async {
    final CurrencyTextInputFormatter _formatadorDinheiro =
    CurrencyTextInputFormatter(
        locale: 'pt-br', decimalDigits: 2, symbol: "R\$");

    tipo = tipoTransacao;

    dataTransacaoController = TextEditingController(text: Utils.formatarData_ddMMyyyy(DateTime.now()));

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
                  constraints: BoxConstraints(
                    minWidth: 250,
                    maxWidth: 350,
                    minHeight: 250,
                    maxHeight: 365,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFF444444)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Adicionar ${tipoTransacao.name.toLowerCase()}',
                            style:
                            TextStyle(color: Colors.white70, fontSize: 20)),
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
                            await _abrirDatePicker(context);
                          },
                          onChanged: (value) async {
                            await _abrirDatePicker(context);
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          child: const Text('Salvar'),
                          onPressed: () => _cadastrarTransacao(context),
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

  Future<void> editar(
      BuildContext context, String? _codigo) async {
    if(_codigo == null)
      {
        Utils.message(context, "Código da transação está inválido");
        return;
      }

    codigo = _codigo;

    TransacaoDTO? transacao = await ApiService.retornar(_codigo);

    if(transacao == null)
    {
      Utils.message(context, "Transação não encontrada");
      return;
    }

    dataTransacaoController = TextEditingController(text: Utils.formatarData_ddMMyyyy(transacao.data));
    tipo = transacao.tipo;
    valor = transacao.valor;
    dataTransacao = transacao.data;
    descricao = transacao.descricao;

    final CurrencyTextInputFormatter _formatadorDinheiro =
    CurrencyTextInputFormatter(
        locale: 'pt-br', decimalDigits: 2, symbol: "R\$");

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
                  constraints: BoxConstraints(
                    minWidth: 250,
                    maxWidth: 350,
                    minHeight: 250,
                    maxHeight: 365,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFF444444)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Alterar ${transacao.tipo.name.toLowerCase()}',
                            style:
                            TextStyle(color: Colors.white70, fontSize: 20)),
                        SizedBox(height: 20),
                        MyTextField(
                          validator: _validadorDescricao,
                          onChanged: (value) {
                            descricao = value;
                          },
                          labelText: "Descrição",
                          iconData: Icons.message,
                          initialValue: transacao.descricao,
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
                          initialValue: Utils.formatarValor(transacao.valor),
                        ),
                        MyTextField(
                          labelText: "Data",
                          controller: dataTransacaoController,
                          iconData: Icons.calendar_today,
                          onTap: () async {
                            await _abrirDatePicker(context);
                          },
                          onChanged: (value) async {
                            await _abrirDatePicker(context);
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          child: const Text('Salvar'),
                          onPressed: () => _editarTransacao(context),
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

  Future<void> _abrirDatePicker(BuildContext context) async {
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

  void _cadastrarTransacao(BuildContext context) async {
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
    ApiService.cadastrar(transacao).then((mensagem) {
      Utils.message(context, mensagem);
      Navigator.pop(context);
    });
  }

  void _editarTransacao(BuildContext context) async {
    bool valido = _formKey.currentState?.validate() ?? false;

    if (!valido) {
      return;
    }
    TransacaoDTO transacao = TransacaoDTO(
      codigo: codigo,
      tipo: tipo,
      valor: valor,
      data: dataTransacao,
      descricao: descricao,
    );
    ApiService.editar(transacao).then((mensagem) {
      Utils.message(context, mensagem);
      Navigator.pop(context);
    });
  }

  Future<List<TransacaoDTO>> retornarTransacoes(BuildContext context) async {
    try {
      return await ApiService.listar();
    } catch (error) {
      Utils.message(context, "Ocorreu um erro ao retornar as transações");
      print(error);
      return [];
    }
  }
}