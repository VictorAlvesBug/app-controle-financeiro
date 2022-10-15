import 'dart:io';

import 'package:controle_financeiro/components/app_logo.dart';
import 'package:controle_financeiro/screens/home_screen.dart';
import 'package:controle_financeiro/screens/register_screen.dart';
import 'package:controle_financeiro/utils/utils.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _counter = 0;

  void _incrementCounter() {
    _counter++;
    setState(() {});
  }

  var userEmail = '';
  var userPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                AppLogo(size: 60),
                SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    label: Text('E-mail'),
                  ),
                  onChanged: (newText) => userEmail = newText,
                ),
                const SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('Senha'),
                  ),
                  onChanged: (newText) => userPassword = newText,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    const targetEmail = 'email@fake.com';
                    const targetPassword = '123';
                    if(targetEmail == userEmail && targetPassword == userPassword){
                      Utils.Message(context, 'Login fake realizado com sucesso');
                      Navigator.pushReplacementNamed(context, HomeScreen.id);
                    }
                    else {
                      Utils.Message(context, 'Login não implementado...');
                      Utils.Message(context, 'Tente logar com e-mail: $targetEmail  e senha: $targetPassword');
                    }
                  },
                  child: const Text('Entrar'),
                ),
                const SizedBox(height: 5),
                Center(child: Text('-------------------- ou --------------------')),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, RegisterScreen.id);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                      side: BorderSide(color: Colors.blue),
                      foregroundColor: Colors.blue
                  ),
                  child: const Text('Cadastre-se'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}