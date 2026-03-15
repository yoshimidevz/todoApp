import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? labelText;
  final Widget? prefixIcon;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.labelText,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
      ),
    );
  }
}