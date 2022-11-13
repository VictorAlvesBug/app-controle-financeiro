import 'package:controle_financeiro/src/components/app_logo.dart';
import 'package:controle_financeiro/src/screens/home_screen.dart';
import 'package:flutter/material.dart';

import '../services/login_service.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String id = 'splash_screen';

  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () async {
      String? userId = await LoginService().retornarUserId();

      if (userId == null || userId.length == 0) {
        Navigator.pushReplacementNamed(context, LoginScreen.id);
      } else {
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }
    });

    return const Scaffold(
      backgroundColor: const Color(0xFF444444),
      body: SafeArea(
        child: Center(child: AppLogo(size: 80, exibirSlogan: true)),
      ),
    );
  }
}
