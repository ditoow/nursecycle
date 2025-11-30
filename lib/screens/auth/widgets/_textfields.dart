import 'package:flutter/material.dart';
import 'package:nursecycle/core/colorconfig.dart';

class TTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  // final VoidCallback? onSuffixTap;

  const TTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    // this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      width: double.infinity,
      child: TextField(
        style: TextStyle(fontSize: 14),
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          // enabledBorder: UnderlineInputBorder(
          //   borderSide: BorderSide(color: primaryColor),
          // ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          focusColor: primaryColor,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: label,
          labelStyle: TextStyle(fontSize: 14),
          hintText: hintText,
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Icon(prefixIcon, size: 20),
                )
              : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
          // suffixIcon: suffixIcon != null
          //     ? GestureDetector(
          //         onTap: onSuffixTap,
          //         child: Icon(suffixIcon),
          //       )
          //     : null,
        ),
      ),
    );
  }
}
