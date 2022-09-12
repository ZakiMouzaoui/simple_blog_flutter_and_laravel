import 'package:flutter/material.dart';


class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({Key? key,
    required this.labelText,
    required this.controller,
    required this.validation,
    this.isObscure=false,
    this.type=TextInputType.text, this.maxLines=1,
  }) : super(key: key);

  final String labelText;
  final TextEditingController controller;
  final String? Function(String?) validation;
  final bool isObscure;
  final TextInputType type;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      keyboardType: type,
      obscureText: isObscure,
      validator: validation,
      controller: controller,
      cursorColor: Colors.amber,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelStyle: const TextStyle(
            color: Colors.amber
        ),
        labelText: labelText,
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
                color: Colors.redAccent
            )
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
                color: Colors.amber
            )
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
                color: Colors.amber
            )
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
                color: Colors.redAccent
            )
        ),
      ),
    );
  }
}
