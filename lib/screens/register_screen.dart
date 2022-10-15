import 'dart:io';

import 'package:controle_financeiro/components/app_logo.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                    label: Text('Informe seu e-mail'),
                  ),
                  onChanged: (newText) => userEmail = newText,
                ),
                const SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('Crie uma senha'),
                  ),
                  onChanged: (newText) => userPassword = newText,
                ),
                const SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('Confirme a senha'),
                  ),
                  onChanged: (newText) => userPassword = newText,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Utils.Message(context, 'Cadastro não implementado...');
                  },
                  child: const Text('Cadastrar'),
                ),
                const SizedBox(height: 5),
                Center(child: Text('-------------------- ou --------------------')),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, LoginScreen.id);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                    side: BorderSide(color: Colors.blue),
                    foregroundColor: Colors.blue
                  ),
                  child: const Text('Já tenho cadastro'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}