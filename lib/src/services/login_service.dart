import 'dart:convert';

import 'package:controle_financeiro/src/utils/routes.dart';
import 'package:http/http.dart' as http;

class LoginService {
  dynamic login(String email, String password) async {
    http.Response response = await http.post(
      Uri.parse(Routes.urlLogin),
      body: json.encode(
        {
          "email": email,
          "password": password,
          "returnSecureToken": true,
        },
      ),
    );

    dynamic bodyJson = json.decode(response.body);
    print(response.body);
    if (response.statusCode == 400) {
      return {
        'sucesso': false,
        'mensagem': retornarMensagem(bodyJson['error']['message']),
        'idToken': null
      };
      //print(bodyJson['error']['message']);
    } else {
      return {
        'sucesso': true,
        'mensagem': 'Login realizado com sucesso',
        'idToken': bodyJson['idToken']
      };
      print(bodyJson['idToken']);
    }
  }

  String retornarMensagem(String respostaLogin){
    switch(respostaLogin)
    {
      case 'INVALID_EMAIL': return 'Informe um e-mail válido';
      case 'EMAIL_NOT_FOUND': return 'E-mail ou senha inválidos';
      case 'INVALID_PASSWORD': return 'E-mail ou senha inválidos';
      case 'MISSING_PASSWORD': return 'Informe a senha';
      default: return 'Erro ao realizar login';
    }
  }
}
