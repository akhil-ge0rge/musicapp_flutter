import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isObscure;
  final bool isReadOnly;
  final VoidCallback? onTap;

  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscure = false,
    this.isReadOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      obscureText: isObscure,
      readOnly: isReadOnly,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return '$hintText is Missing';
        }
        return null;
      },
      onTap: onTap,
    );
  }
}
