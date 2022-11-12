import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    Key? key,
    required this.size,
    this.exibirSlogan,
  }) : super(key: key);

  final double size;
  final bool? exibirSlogan;

  @override
  Widget build(BuildContext context) {
    final double logoWidth = size;
    final double sizedBoxHeight = size / 10;
    final double textFontSize = size * 0.30;

    Widget textSlogan = SizedBox();

    if(exibirSlogan == true) {
      textSlogan = Text(
        'Seu maior aliado na conquista da sua liberdade financeira',
        style: GoogleFonts.fuzzyBubbles(
          fontSize: textFontSize * 0.7,
          color: Colors.amber,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        child: Column(
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
              'Controle Financeiro',
              style: GoogleFonts.fuzzyBubbles(
                fontSize: textFontSize,
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            textSlogan
          ],
        ),
      ),
    );
  }
}
