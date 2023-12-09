import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final String? initialValue;
  final TextEditingController controller;
  final void Function(dynamic) onChanged;
  final bool obscured;
  final TextInputType keyboardType;
  final bool formatted;
  final IconData usedIcon;

  const CustomTextField({
    Key? key,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.obscured = false,
    this.keyboardType = TextInputType.text,
    this.formatted = false,
    required this.usedIcon,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [
        formatted
            ? FilteringTextInputFormatter.deny(RegExp(r'\s')) // Deny spaces
            : FilteringTextInputFormatter.deny(RegExp(r'')),
      ],
      keyboardType: keyboardType,
      obscureText: obscured,
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        icon: Icon(
          usedIcon,
          color: Colors.deepPurple,
        ),
        isDense: true,
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}
