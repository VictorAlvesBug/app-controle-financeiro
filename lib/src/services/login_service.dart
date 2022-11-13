import 'dart:convert';

import 'package:controle_financeiro/src/utils/routes.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    if (response.statusCode == 400) {
      return {
        'sucesso': false,
        'mensagem': retornarMensagem(bodyJson['error']['message']),
        'idToken': null
      };
    } else {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('userId', bodyJson['localId']);
      sharedPreferences.setString('displayName', bodyJson['displayName']);

      return {
        'sucesso': true,
        'mensagem': 'Login realizado com sucesso',
        'idToken': bodyJson['idToken']
      };
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

  Future<String?> retornarUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('userId');
  }

  Future<String?> retornarDisplayName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('displayName');
  }

  Future<String> retornarFirstName() async {
    String displayName = await retornarDisplayName() ?? "Usuário Teste";
    return displayName.split(' ').elementAt(0);
  }

  Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('userId');
  }
}
