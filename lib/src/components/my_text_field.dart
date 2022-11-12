import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  MyTextField({
    Key? key,
    required this.labelText,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.iconData,
  }) : super(key: key);

  bool obscureText;
  final String? Function(String?)? validator;
  final String labelText;
  final Function(String)? onChanged;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          floatingLabelStyle: TextStyle(color: Colors.blue),
          labelStyle: TextStyle(color: Colors.white70),
          label: Text(
            labelText,
          ),
          focusColor: Colors.white70,
          icon: iconData == null ? null : Icon(iconData),
        ),
        onChanged: onChanged,
        style: TextStyle(color: Colors.white70),
      ),
    );
  }
}
