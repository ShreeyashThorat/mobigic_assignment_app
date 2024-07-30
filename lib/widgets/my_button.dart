import 'package:flutter/material.dart';

import '../utils/constant_data.dart';

class MyElevatedButton extends StatefulWidget {
  final Function()? onPress;
  final Color? buttonColor;
  final double? elevation;
  final Widget buttonContent;
  final bool? disableButton;
  final BorderSide? border;
  final double? width;
  final double? height;
  const MyElevatedButton(
      {super.key,
      required this.onPress,
      required this.buttonContent,
      this.buttonColor,
      this.elevation,
      this.border,
      this.disableButton,
      this.height,
      this.width});

  @override
  State<MyElevatedButton> createState() => _MyElevatedButtonState();
}

class _MyElevatedButtonState extends State<MyElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: ElevatedButton(
          style: ButtonStyle(
              elevation: WidgetStateProperty.all(widget.elevation),
              backgroundColor: WidgetStateProperty.all<Color>(
                  widget.buttonColor ?? ColorTheme.primaryColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                side: widget.border ?? BorderSide.none,
                borderRadius: BorderRadius.circular(10.0),
              ))),
          onPressed: widget.disableButton == true ? null : widget.onPress,
          child: widget.buttonContent),
    );
  }
}