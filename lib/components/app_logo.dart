import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLogo extends StatelessWidget {

  const AppLogo({
    Key? key,
    required this.size,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    final double logoWidth = size;
    final double sizedBoxHeight = size / 10;
    final double textFontSize = size * 0.22;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: logoWidth,
          child: Image.asset(
            'assets/images/logo.png',
            color: Colors.amber,
          ),
        ),
        SizedBox(
          height: sizedBoxHeight,
        ),
        Text(
          'Meu Controle Financeiro',
          style: GoogleFonts.fuzzyBubbles(
            fontSize: textFontSize,
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
