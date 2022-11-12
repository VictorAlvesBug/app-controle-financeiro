import '../components/app_logo.dart';
import '../screens/home_screen.dart';
import '../screens/register_screen.dart';
import '../utils/utils.dart';
import 'package:flutter/material.dart';

class CadastrarTransacaoScreen extends StatefulWidget {
  static const String id = 'cadastrar_transacao_screen';

  const CadastrarTransacaoScreen({Key? key}) : super(key: key);

  @override
  State<CadastrarTransacaoScreen> createState() => _CadastrarTransacaoScreenState();
}

class _CadastrarTransacaoScreenState extends State<CadastrarTransacaoScreen> {

  var userEmail = 'email@fake.com';
  var userPassword = '123';

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
                const SizedBox(height: 50),
                const AppLogo(size: 60),
                const SizedBox(height: 10),
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
                      Utils.message(context, 'Login fake realizado com sucesso');
                      Navigator.pushReplacementNamed(context, HomeScreen.id);
                    }
                    else {
                      Utils.message(context, 'Login não implementado...');
                      Utils.message(context, 'Tente logar com e-mail: $targetEmail  e senha: $targetPassword');
                    }
                  },
                  child: const Text('Entrar'),
                ),
                const SizedBox(height: 5),
                const Center(child: Text('-------------------- ou --------------------')),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, RegisterScreen.id);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      side: const BorderSide(color: Colors.blue),
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