import 'dart:convert';
import 'dart:io';

import 'package:controle_financeiro/src/dto/transacao_dto.dart';
import 'package:controle_financeiro/src/services/login_service.dart';
import 'package:controle_financeiro/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';

import '../dto/saldo_dto.dart';
import '../enums/tipo_transacao_enum.dart';
import 'package:http/http.dart' as http;

class ApiService {

  // Abra o CMD > Execute "ipconfig" > Altere a constante abaixo para o IP de Wifi retornado.
  static const _wifiIp = '192.168.15.138';

  static const _apiUrl = 'http://$_wifiIp:3000/api';

  static Future<SaldoDTO> retornarSaldo() async {
    final userId = await LoginService().retornarUserId();
    final uri =
    Uri.parse('$_apiUrl/saldo?userId=$userId');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

    http.Response response = await http.get(uri, headers: headers);

    final responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      double totalReceitas = double.parse(
          responseJson['dados']['totalReceitas'].toString());
      double totalDespesas = double.parse(
          responseJson['dados']['totalDespesas'].toString());
      double saldoTotal = double.parse(
          responseJson['dados']['saldoTotal'].toString());

      SaldoDTO saldoDto = SaldoDTO(
        totalReceitas: totalReceitas,
        totalDespesas: totalDespesas,
        saldoTotal: saldoTotal,
      );

      return saldoDto;
    }

    print(responseJson['mensagem']);
    return SaldoDTO();
  }

  static Future<List<TransacaoDTO>> listar(int mes, int ano) async {
    final userId = await LoginService().retornarUserId();
    final uri =
    Uri.parse('$_apiUrl/transacoes?userId=$userId&mes=$mes&ano=$ano');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

    http.Response response = await http.get(uri, headers: headers);

    final responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<TransacaoDTO> listaRetorno = responseJson['dados']
          .map<TransacaoDTO>((transacaoJson) =>
          TransacaoDTO(
            codigo: transacaoJson['codigo'],
            tipo: transacaoJson['tipo'] == 'R'
                ? TipoTransacaoEnum.Receita
                : TipoTransacaoEnum.Despesa,
            valor: double.parse(transacaoJson['valor'].toString()),
            data: DateTime.parse(transacaoJson['dataTransacao']),
            descricao: transacaoJson['nome'],
            dataHoraCadastro:
            DateTime.parse(transacaoJson['dataHoraCadastro']),
          ))
          .toList();

      return listaRetorno;
    }

    print(responseJson['mensagem']);
    return [];
  }

  static Future<TransacaoDTO?> retornar(String codigo) async {
    final userId = await LoginService().retornarUserId();
    final uri = Uri.parse('$_apiUrl/transacoes/$codigo?userId=$userId');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

    http.Response response = await http.get(uri, headers: headers);

    final responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<TransacaoDTO> listaRetorno = responseJson['dados']
          .map<TransacaoDTO>((transacaoJson) =>
          TransacaoDTO(
            codigo: transacaoJson['codigo'],
            tipo: transacaoJson['tipo'] == 'R'
                ? TipoTransacaoEnum.Receita
                : TipoTransacaoEnum.Despesa,
            valor: double.parse(transacaoJson['valor'].toString()),
            data: DateTime.parse(transacaoJson['dataTransacao']),
            descricao: transacaoJson['nome'],
            dataHoraCadastro:
            DateTime.parse(transacaoJson['dataHoraCadastro']),
          ))
          .toList();

      return listaRetorno.elementAt(0);
    }

    print(responseJson['mensagem']);
    return null;
  }

  static Future<String> cadastrar(TransacaoDTO transacao) async {
    try {
      final userId = await LoginService().retornarUserId();
      final uri = Uri.parse('$_apiUrl/transacoes?userId=$userId');
      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      final body = json.encode({
        "nome": transacao.descricao,
        "valor": transacao.valor,
        "tipo": transacao.ehReceita() ? 'R' : 'D',
        "dataTransacao": Utils.formatarData_yyyyMMdd(transacao.data),
      });

      http.Response response =
      await http.post(uri, headers: headers, body: body);

      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 201 && responseJson['sucesso']) {
        return responseJson['mensagem'];
      }

      return responseJson['mensagem'];
    } catch (error) {
      return error.toString();
    }
  }

  static Future<String> editar(TransacaoDTO transacao) async {
    try {
      final userId = await LoginService().retornarUserId();
      final uri =
      Uri.parse('$_apiUrl/transacoes/${transacao.codigo}?userId=$userId');
      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      final body = json.encode({
        "nome": transacao.descricao,
        "valor": transacao.valor,
        "tipo": transacao.ehReceita() ? 'R' : 'D',
        "dataTransacao": Utils.formatarData_yyyyMMdd(transacao.data),
      });

      http.Response response =
      await http.patch(uri, headers: headers, body: body);

      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200 && responseJson['sucesso']) {
        return responseJson['mensagem'];
      }

      return responseJson['mensagem'];
    } catch (error) {
      return error.toString();
    }
  }

  static Future<String> deletar(String? codigo) async {
    try {
      if (codigo == null) {
        return "C??digo da transa????o est?? inv??lido";
      }

      final userId = await LoginService().retornarUserId();
      final uri = Uri.parse('$_apiUrl/transacoes/$codigo?userId=$userId');
      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

      http.Response response = await http.delete(uri, headers: headers);

      if (response.statusCode == 204) {
        return "Transa????o removida com sucesso";
      }

      final responseJson = jsonDecode(response.body);
      return responseJson['mensagem'];
    } catch (error) {
      return error.toString();
    }
  }
}
