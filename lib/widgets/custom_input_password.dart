import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'const.dart';

class CustomInputPassword extends StatefulWidget {
  final Function(String) onChanged;
  // ignore: use_key_in_widget_constructors
  const CustomInputPassword({required this.onChanged});

  @override
  State<CustomInputPassword> createState() => _CustomInputPasswordState();
}

class _CustomInputPasswordState extends State<CustomInputPassword> {
  bool _passwordVisible = false;
  final TextEditingController _userPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(13)),
      child: TextFormField(
        onChanged: widget.onChanged,
        cursorColor: Consts.colorB,
        keyboardType: TextInputType.text,
        controller: _userPasswordController,
        obscureText: !_passwordVisible, //This will obscure text dynamically
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          border: InputBorder.none,
          //labelText: 'Password',
          hintText: AppLocalizations.of(context).password,
          // Here is key idea
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Consts.appBarColor,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}
