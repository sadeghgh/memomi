import 'package:flutter/material.dart';
import 'package:memomi/widgets/const.dart';

class CustomButton extends StatelessWidget {
  // This finals are for our Custom botton
  final String text;
  final VoidCallback onTap;
  final bool mode;
  final bool loading;

  // ignore: use_key_in_widget_constructors
  const CustomButton(
      {required this.text,
      required this.onTap,
      required this.mode,
      required this.loading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
            border: Border.all(color: Consts.backGroundColor, width: 2),
            borderRadius: BorderRadius.circular(13),
            color: mode ? Consts.backGroundColor : Consts.appBarColor),
        margin: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 25,
        ),
        child: Stack(
          children: [
            Visibility(
              visible: loading ? false : true,
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color:
                          mode ? Consts.appBarColor : Consts.backGroundColor),
                ),
              ),
            ),
            Visibility(
              visible: loading ? true : false,
              child: const Center(
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
