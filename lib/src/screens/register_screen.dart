import '../components/app_logo.dart';
import '../components/labeled_divider.dart';
import '../components/my_text_field.dart';
import '../screens/home_screen.dart';
import '../services/login_service.dart';
import '../services/register_service.dart';
import '../utils/utils.dart';
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
  bool exibirSenha = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
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
                      validator: (value) {
                        String email = value ?? "";
                        RegExp regexEmail = RegExp(
                            r"^\w+((-\w+)|(\.\w+))*\@\w+((\.|-)\w+)*\.\w+$");

                        if (regexEmail.allMatches(email).isEmpty) {
                          return "Informe um e-mail válido";
                        }

                        return null;
                      },
                      labelText: 'Informe seu e-mail',
                      onChanged: (value) => userEmail = value.toLowerCase(),
                      iconData: Icons.alternate_email_outlined,
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
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

                        if (regexContemLetraMinuscula
                            .allMatches(senha)
                            .isEmpty) {
                          return "A senha deve conter ao menos uma letra minúscula";
                        }

                        if (regexContemLetraMaiuscula
                            .allMatches(senha)
                            .isEmpty) {
                          return "A senha deve conter ao menos uma letra maiúscula";
                        }

                        return null;
                      },
                      obscureText: !exibirSenha,
                      labelText: 'Crie uma senha',
                      onChanged: (newText) => userPassword = newText,
                      iconData: Icons.lock_outline,
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      validator: (value) {
                        String confirmacaoSenha = value ?? "";

                        if (confirmacaoSenha != userPassword) {
                          return "As senhas estão diferentes";
                        }

                        return null;
                      },
                      obscureText: !exibirSenha,
                      labelText: 'Confirme a senha',
                      onChanged: (newText) =>
                          userPasswordConfirmation = newText,
                      iconData: Icons.lock_outline,
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      title: Text('Exibir senha', style: TextStyle(color: Colors.white70)),
                      controlAffinity: ListTileControlAffinity.leading,
                      // ListTileControlAffinity.trailing
                      value: exibirSenha,
                      onChanged: (value) {
                        exibirSenha = value!;
                        setState(() { });
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
      ),
    );
  }

  void _registrar() async {
    bool valido = _formKey.currentState?.validate() ?? false;

    if (valido) {
      dynamic registerResponse =
          await RegisterService().register(userEmail, userPassword);

      if(!registerResponse['sucesso']){
        Utils.message(context, registerResponse['mensagem']);
        return;
      }

      dynamic loginResponse =
          await LoginService().login(userEmail, userPassword);

      if (!loginResponse['sucesso']) {
        Utils.message(context, loginResponse['mensagem']);
        return;
      }

        Utils.message(context, loginResponse['mensagem']);
        Navigator.pushReplacementNamed(context, HomeScreen.id);
    }
  }
}
