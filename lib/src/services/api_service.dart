import 'dart:convert';
import 'dart:io';

import 'package:controle_financeiro/src/dto/transacao_dto.dart';
import 'package:controle_financeiro/src/services/login_service.dart';
import 'package:controle_financeiro/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/tipo_transacao_enum.dart';
import '../utils/routes.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const _apiUrl = 'http://localhost:3000/api';

  Future<List<TransacaoDTO>> retornarTransacoes() async {
    try {
      final userId = await LoginService().retornarUserId();
      final uri = Uri.parse('$_apiUrl/transacoes?userId=$userId');
      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

      http.Response response = await http.get(uri, headers: headers);

      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        List<TransacaoDTO> listaRetorno = responseJson['dados']
            .map<TransacaoDTO>((transacaoJson) => TransacaoDTO(
                  codigo: transacaoJson['codigo'],
                  tipo: transacaoJson['tipo'] == 'R'
                      ? TipoTransacaoEnum.Receita
                      : TipoTransacaoEnum.Despesa,
                  valor: transacaoJson['valor'],
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
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<String> cadastrarTransacao(TransacaoDTO transacao) async {
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
}
