import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Formscreening extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool readOnly; // Tambah ini
  final VoidCallback? onTap; // Tambah ini
  final ValueChanged<String>? onChanged; // Tambah ini
  final int maxLines; // Tambah ini (opsional)
  final List<TextInputFormatter>? inputFormatters;
  final String? suffix;

  const Formscreening({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false, // Default false
    this.onTap, // Tambah ini
    this.onChanged,
    this.maxLines = 1, // Default 1 baris
    this.inputFormatters,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxLines > 1 ? null : 52, // Kalau multiline, height auto
      width: double.infinity,
      child: TextField(
        style: TextStyle(fontSize: 14),
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        readOnly: readOnly, // Tambah ini
        onTap: onTap, // Tambah ini
        onChanged: onChanged,
        maxLines: maxLines, // Tambah ini
        decoration: InputDecoration(
          suffixText: suffix,
          fillColor: const Color.fromARGB(255, 133, 42, 42).withAlpha(26),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: label,
          labelStyle: TextStyle(fontSize: 14),
          hintText: hintText,
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Icon(prefixIcon, size: 20),
                )
              : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 20) : null,
        ),
      ),
    );
  }
}
