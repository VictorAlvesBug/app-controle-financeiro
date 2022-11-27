import 'dart:convert';

import '../utils/routes.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  dynamic register(String nomeUsuario, String email, String password) async {
    http.Response response = await http.post(
      Uri.parse(Routes.urlRegister),
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
        'alterarParaLoginScreen': bodyJson['error']['message'] == 'EMAIL_EXISTS',
        'idToken': null
      };
    } else {
      var idToken = bodyJson['idToken'];

      await _gravarNomeUsuario(idToken, nomeUsuario);

      return {
        'sucesso': true,
        'mensagem': 'Cadastro realizado com sucesso',
        'alterarParaLoginScreen': false,
        'idToken': idToken
      };
    }
  }

  Future<void> _gravarNomeUsuario(String idToken, String nomeUsuario) async {
    http.Response response = await http.post(
      Uri.parse(Routes.urlGravarNomeUsuario),
      body: json.encode(
        {
          "idToken": idToken,
          "displayName": nomeUsuario,
          "photoUrl": "",
          "deleteAttribute": ["PHOTO_URL"],
          "returnSecureToken": true,
        },
      ),
    );
  }

  String retornarMensagem(String respostaCadastro){
    switch(respostaCadastro)
    {
      case 'EMAIL_EXISTS': return 'E-mail já cadastrado';
      default: return 'Erro ao realizar cadastro';
    }
  }
}