import 'package:controle_financeiro/components/app_logo.dart';
import 'package:controle_financeiro/components/labeled_divider.dart';
import 'package:controle_financeiro/screens/home_screen.dart';
import 'package:controle_financeiro/screens/register_screen.dart';
import 'package:controle_financeiro/services/login_service.dart';
import 'package:controle_financeiro/utils/utils.dart';
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
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('E-mail'),
                      ),
                      onChanged: (value) => userEmail = value.toLowerCase(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        label: Text('Senha'),
                      ),
                      onChanged: (value) => userPassword = value,
                    ),
                    const SizedBox(height: 20),
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
                          backgroundColor: Colors.deepPurple,
                          side: const BorderSide(color: Colors.blue),
                          foregroundColor: Colors.blue),
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

  void _logar() async {
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
