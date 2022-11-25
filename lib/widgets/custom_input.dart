import 'package:flutter/material.dart';
import 'package:memomi/widgets/const.dart';

class CustomInput extends StatelessWidget {
  final String hinttext;
  final Function(String) onChanged;
  final bool checkPassword;
  final TextInputType keyboardType;
  final int maxLength;
  final int maxLines;
  // ignore: use_key_in_widget_constructors
  const CustomInput(
      {required this.hinttext,
      required this.onChanged,
      required this.checkPassword,
      required this.keyboardType,
      required this.maxLength,
      required this.maxLines});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(13)),
      child: TextField(
        maxLength: maxLength,
        maxLines: maxLines,
        keyboardType: keyboardType,
        obscureText: checkPassword,
        onChanged: onChanged,
        cursorColor: Consts.colorB,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hinttext,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 22, vertical: 22)),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
