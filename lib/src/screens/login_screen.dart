import 'package:controle_financeiro/src/components/app_logo.dart';
import 'package:controle_financeiro/src/components/labeled_divider.dart';
import 'package:controle_financeiro/src/components/my_text_field.dart';
import 'package:controle_financeiro/src/screens/home_screen.dart';
import 'package:controle_financeiro/src/screens/register_screen.dart';
import 'package:controle_financeiro/src/services/login_service.dart';
import 'package:controle_financeiro/src/utils/utils.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var userEmail = '';
  var userPassword = '';

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
                      validator: _validadorEmail,
                      labelText: 'E-mail',
                      onChanged: (value) => userEmail = value.toLowerCase(),
                      iconData: Icons.alternate_email_outlined,
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      validator: _validadorSenha,
                      labelText: 'Senha',
                      obscureText: !exibirSenha,
                      onChanged: (value) => userPassword = value,
                      iconData: Icons.lock_outline,
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      title: Text('Exibir senha', style: TextStyle(color: Colors.white70)),
                      controlAffinity: ListTileControlAffinity.leading, // ListTileControlAffinity.trailing
                      value: exibirSenha,
                      onChanged: (value) {
                        exibirSenha = value!;
                        setState(() { });
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _logar,
                      child: const Text('Entrar'),
                    ),
                    LabeledDivider(text: 'ou', verticalPadding: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, RegisterScreen.id);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF444444),
                          side: BorderSide(color: Theme.of(context).primaryColorLight),
                          foregroundColor: Theme.of(context).primaryColorLight),
                      child: const Text('Criar conta'),
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

  String? _validadorEmail(String? value){
    String email = value ?? "";
    RegExp regexEmail = RegExp(
        r"^\w+((-\w+)|(\.\w+))*\@\w+((\.|-)\w+)*\.\w+$");

    if (regexEmail.allMatches(email).isEmpty) {
      return "Informe um e-mail válido";
    }

    return null;
  }

  String? _validadorSenha(String? value){
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

  void _logar() async {
    bool valido = _formKey.currentState?.validate() ?? false;

    if(!valido)
      {
        return;
      }
    dynamic loginResponse = await LoginService().login(userEmail, userPassword);

    if(loginResponse['sucesso']){
      Utils.message(context, loginResponse['mensagem']);
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    }
    else{
      Utils.message(context, loginResponse['mensagem']);
    }

  }
}
