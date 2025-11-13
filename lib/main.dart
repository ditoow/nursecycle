import 'package:flutter/material.dart';
import 'package:nursecycle/core/theme.dart';
import 'package:nursecycle/screens/auth/registerpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nursecycle',
      theme: AppTheme.lightTheme,
      home: Registerpage(),
    );
  }
}
