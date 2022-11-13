import 'dart:convert';
import 'dart:io';

import 'package:controle_financeiro/src/dto/transacao_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/tipo_transacao_enum.dart';
import '../utils/routes.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const _apiUrl = 'http://192.168.15.138:3000/api';

  Future<List<TransacaoDTO>> retornarTransacoes() async {
    final userId = 'UsuarioA'; // await retornarUserId();
    final uri = Uri.parse('$_apiUrl/transacoes?userId=$userId');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

    http.Response response = await http.get(uri, headers: headers);

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final dados = json['dados'];
      List<TransacaoDTO> listaRetorno = [];

      if (dados is List<dynamic>) {
        for (var item in dados) {
          listaRetorno.add(TransacaoDTO(
            codigo: item['codigo'],
            tipo: item['tipo'] == 'R'
                ? TipoTransacaoEnum.Receita
                : TipoTransacaoEnum.Despesa,
            valor: item['valor'],
            data: DateTime.parse(item['dataTransacao']),
            descricao: item['nome'],
            dataHoraCadastro: DateTime.parse(item['dataHoraCadastro']),
          ));
        }
      }
      return listaRetorno;
    }

    print(json['mensagem']);
    return [];
  }

  Future<String?> retornarUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('userId');
  }
}
