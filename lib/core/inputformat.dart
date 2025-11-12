import 'package:flutter/services.dart';

class AppInputFormatters {
  // Hanya angka
  static final List<TextInputFormatter> digitsOnly = [
    FilteringTextInputFormatter.digitsOnly,
  ];

  // Angka + desimal
  static final List<TextInputFormatter> decimal = [
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
  ];

  // Hanya huruf (opsional)
  static final List<TextInputFormatter> lettersOnly = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
  ];
}
