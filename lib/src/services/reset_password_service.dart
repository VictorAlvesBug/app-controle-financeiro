import 'dart:convert';

import '../utils/routes.dart';
import 'package:http/http.dart' as http;

class ResetPasswordService {
  dynamic sendResetPasswordCode(String email, String password) async {
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
        'mensagem': 'Cadastro realizado com sucesso',
        'idToken': bodyJson['idToken']
      };
      print(bodyJson['idToken']);
    }
  }

  String retornarMensagem(String respostaCadastro){
    switch(respostaCadastro)
    {
      case 'EMAIL_EXISTS': return 'E-mail já cadastrado';
      default: return 'Erro ao realizar cadastro';
    }
  }
}
