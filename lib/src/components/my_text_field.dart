import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  MyTextField({
    Key? key,
    required this.labelText,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.iconData,
    this.onTap,
    this.controller,
    this.inputFormatters,
    this.keyboardType,
    this.initialValue,
  }) : super(key: key);

  bool obscureText;
  final String? Function(String?)? validator;
  final String labelText;
  final Function(String)? onChanged;
  final IconData? iconData;
  final GestureTapCallback? onTap;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          floatingLabelStyle:
              TextStyle(color: Theme.of(context).primaryColorLight),
          labelStyle: TextStyle(color: Colors.white70),
          label: Text(
            labelText,
          ),
          focusColor: Colors.white70,
          icon: iconData == null ? null : Icon(iconData),
          errorStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
        onChanged: onChanged,
        style: TextStyle(color: Colors.white70),
        onTap: onTap,
        controller: controller,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        initialValue: initialValue,
      ),
    );
  }
}
