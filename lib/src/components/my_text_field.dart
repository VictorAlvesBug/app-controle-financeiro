import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  MyTextField({
    Key? key,
    required this.labelText,
    this.textCapitalization = TextCapitalization.none,
    this.enableInteractiveSelection = true,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.iconData,
    this.onTap,
    this.controller,
    this.inputFormatters,
    this.keyboardType,
    this.initialValue,
    this.onFieldSubmitted,
    this.textInputAction,
    this.valido = false,
  }) : super(key: key);

  TextCapitalization textCapitalization;
  bool enableInteractiveSelection;
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
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;

  bool valido;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          TextFormField(
            textCapitalization: textCapitalization,
            enableInteractiveSelection: enableInteractiveSelection,
            obscureText: obscureText,
            validator: validator,
            decoration: InputDecoration(
              floatingLabelStyle:
                  TextStyle(color: Theme.of(context).primaryColorLight),
              labelStyle: const TextStyle(color: Colors.white70),
              label: Text(
                labelText,
              ),
              focusColor: Colors.white70,
              icon: iconData == null ? null : Icon(iconData),
              errorStyle: const TextStyle(color: Colors.deepOrange),
            ),
            onChanged: onChanged,
            style: const TextStyle(color: Colors.white70),
            onTap: onTap,
            controller: controller,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            initialValue: initialValue,
            onFieldSubmitted: onFieldSubmitted,
            textInputAction: textInputAction,
          ),
          Positioned(
            right: 10,
            child: valido
                ? const Icon(Icons.check, color: Colors.green)
                : const Text(""),
          ),
        ],
      ),
    );
  }
}
