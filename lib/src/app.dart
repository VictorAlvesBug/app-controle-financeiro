import 'package:controle_financeiro/src/screens/cadastrar_transacao_screen.dart';
import 'package:controle_financeiro/src/screens/home_screen.dart';
import 'package:controle_financeiro/src/screens/login_screen.dart';
import 'package:controle_financeiro/src/screens/register_screen.dart';
import 'package:controle_financeiro/src/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Controle Financeiro',
        theme: ThemeData(
          primaryColor: Colors.indigo,
          primaryColorLight: Colors.orange,
          primaryColorDark: Colors.black12,
          primarySwatch: Colors.indigo,
        ),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => const SplashScreen(),
          HomeScreen.id: (context) => const HomeScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          RegisterScreen.id: (context) => const RegisterScreen(),
          CadastrarTransacaoScreen.id: (context) => const CadastrarTransacaoScreen(),
        });
  }
}
