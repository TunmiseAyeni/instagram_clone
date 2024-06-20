import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  const TextInputField(
      {super.key,
      required this.text,
      this.icon,
      required this.controller,
      required this.keyboardType,
      this.iconButton,
      this.obscureText = false});

  final String text;
  final Icon? icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconButton? iconButton;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: iconButton,
        hintText: text,
        prefixIcon: icon,
        //to style the border of the text field
        border: OutlineInputBorder(
          borderSide: Divider.createBorderSide(context),
        ),
        //focused border is the border that appears when the text field is selected
        focusedBorder: OutlineInputBorder(
          borderSide: Divider.createBorderSide(context),
        ),
        //enabled border is the border that appears when the text field is not selected
        enabledBorder: OutlineInputBorder(
          borderSide: Divider.createBorderSide(context),
        ),
        contentPadding: const EdgeInsets.all(10.0),
        //this is to make the text field fill the width of the screen
        filled: true,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }
}
