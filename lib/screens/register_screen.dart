import 'package:controle_financeiro/components/app_logo.dart';
import 'package:controle_financeiro/services/register_service.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var userEmail = '';
  var userPassword = '';
  var userPasswordConfirmation = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const AppLogo(size: 60),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      String email = value ?? "";
                      RegExp regexEmail = RegExp(
                          r"^\w+((-\w+)|(\.\w+))*\@\w+((\.|-)\w+)*\.\w+$");

                      if (regexEmail.allMatches(email).isEmpty) {
                        return "Informe um e-mail válido";
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text('Informe seu e-mail'),
                    ),
                    onChanged: (newText) => userEmail = newText,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      String senha = value ?? "";

                      if (senha.length < 8) {
                        return "A senha deve ter ao menos 8 caracteres";
                      }

                      RegExp regexContemNumero = RegExp(r"\d");
                      RegExp regexContemLetraMinuscula = RegExp(r"[a-z]");
                      RegExp regexContemLetraMaiuscula = RegExp(r"[A-Z]");

                      if (regexContemNumero.allMatches(senha).isEmpty) {
                        return "A senha deve conter ao menos um caracter numérico";
                      }

                      if (regexContemLetraMinuscula.allMatches(senha).isEmpty) {
                        return "A senha deve conter ao menos uma letra minúscula";
                      }

                      if (regexContemLetraMaiuscula.allMatches(senha).isEmpty) {
                        return "A senha deve conter ao menos uma letra maiúscula";
                      }

                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      label: Text('Crie uma senha'),
                    ),
                    onChanged: (newText) => userPassword = newText,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      String confirmacaoSenha = value ?? "";

                      if (confirmacaoSenha != userPassword) {
                        return "As senhas estão diferentes";
                      }

                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      label: Text('Confirme a senha'),
                    ),
                    onChanged: (newText) => userPasswordConfirmation = newText,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _registrar();
                    },
                    child: const Text('Cadastrar'),
                  ),
                  const SizedBox(height: 5),
                  const Center(
                      child:
                          Text('-------------------- ou --------------------')),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, LoginScreen.id);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        side: const BorderSide(color: Colors.blue),
                        foregroundColor: Colors.blue),
                    child: const Text('Já tenho cadastro'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _registrar() async {
    bool valido = _formKey.currentState?.validate() ?? false;

    if (valido) {
      RegisterService().register(
        userEmail,
        userPassword,
      );
    }
  }
}
