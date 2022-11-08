import 'package:flutter/material.dart';

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.color,
    this.label,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final Color? color;
  final String? label;

  @override
  Widget build(BuildContext context) {

    return Column(
        children: [
          Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            color: const Color(0xFF444444),
            elevation: 12.0,
            child: IconButton(
              onPressed: onPressed,
              icon: icon,
              color: color,
            ),
        ),
          const SizedBox(height: 5),
          Text(
            label ?? '',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      );
  }
}
