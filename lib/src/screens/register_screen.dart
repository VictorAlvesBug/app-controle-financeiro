import 'package:controle_financeiro/src/components/app_logo.dart';
import 'package:controle_financeiro/src/components/labeled_divider.dart';
import 'package:controle_financeiro/src/components/my_text_field.dart';
import 'package:controle_financeiro/src/screens/home_screen.dart';
import 'package:controle_financeiro/src/services/login_service.dart';
import 'package:controle_financeiro/src/services/register_service.dart';
import 'package:controle_financeiro/src/utils/utils.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var userName = '';
  var userEmail = '';
  var userPassword = '';
  var userPasswordConfirmation = '';

  bool exibirSenha = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF444444),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minWidth: 250, maxWidth: 500),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppLogo(size: 60),
                    const SizedBox(height: 20),
                    MyTextField(
                      validator: _validadorNome,
                      labelText: 'Nome completo',
                      onChanged: (value) => userName = value,
                      iconData: Icons.people_rounded,
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      validator: _validadorEmail,
                      labelText: 'E-mail',
                      onChanged: (value) => userEmail = value.toLowerCase().trim(),
                      iconData: Icons.alternate_email_outlined,
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      validator: _validadorSenha,
                      obscureText: !exibirSenha,
                      labelText: 'Senha',
                      onChanged: (newText) => userPassword = newText,
                      iconData: Icons.lock_outline,
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      validator: _validadorConfirmacaoSenha,
                      obscureText: !exibirSenha,
                      labelText: 'Confirmação da senha',
                      onChanged: (newText) =>
                          userPasswordConfirmation = newText,
                      iconData: Icons.lock_outline,
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      title: Text('Exibir senha',
                          style: TextStyle(color: Colors.white70)),
                      controlAffinity: ListTileControlAffinity.leading,
                      // ListTileControlAffinity.trailing
                      value: exibirSenha,
                      onChanged: (value) {
                        exibirSenha = value!;
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _registrar,
                      child: const Text('Cadastrar'),
                    ),
                    LabeledDivider(text: 'ou', verticalPadding: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, LoginScreen.id);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF444444),
                          side: BorderSide(color: Theme.of(context).primaryColorLight),
                          foregroundColor: Theme.of(context).primaryColorLight),
                      child: const Text('Já tenho cadastro'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validadorNome(String? value) {
    String nome = value ?? "";
    RegExp regexNome = RegExp(r"^(\S)+(\s(\S)+)+$");

    if (regexNome.allMatches(nome).isEmpty) {
      return "Informe seu nome completo";
    }

    return null;
  }

  String? _validadorEmail(String? value) {
    String email = (value ?? "").toLowerCase().trim();
    RegExp regexEmail = RegExp(r"^\w+((-\w+)|(\.\w+))*\@\w+((\.|-)\w+)*\.\w+$");

    if (regexEmail.allMatches(email).isEmpty) {
      return "Informe um e-mail válido";
    }

    return null;
  }

  String? _validadorSenha(String? value) {
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
  }

  String? _validadorConfirmacaoSenha(String? value) {
    String confirmacaoSenha = value ?? "";

    if (confirmacaoSenha != userPassword) {
      return "As senhas estão diferentes";
    }

    return null;
  }

  void _registrar() async {
    bool valido = _formKey.currentState?.validate() ?? false;

    if (!valido) {
      return;
    }

    dynamic registerResponse =
        await RegisterService().register(userName, userEmail, userPassword);

    if (!registerResponse['sucesso']) {
      Utils.message(context, registerResponse['mensagem']);
      return;
    }

    dynamic loginResponse = await LoginService().login(userEmail, userPassword);

    if (!loginResponse['sucesso']) {
      Utils.message(context, loginResponse['mensagem']);
      return;
    }

    Utils.message(context, loginResponse['mensagem']);
    Navigator.pushReplacementNamed(context, HomeScreen.id);
  }
}
