import 'dart:convert';

import 'package:controle_financeiro/utils/routes.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  register(String email, String password) async {
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

    print(response.body);
  }
}
