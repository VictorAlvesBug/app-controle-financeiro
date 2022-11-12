import '../components/app_logo.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String id = 'splash_screen';

  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    });

    return const Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: Center(
          child: AppLogo(size: 80, exibirSlogan: true)
        ),
      ),
    );
  }
}
