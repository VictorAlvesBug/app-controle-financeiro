import 'package:flutter/material.dart';

@immutable
class ButtonLoading extends StatelessWidget {
  const ButtonLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      ),
    );
  }
}
