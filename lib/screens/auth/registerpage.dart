// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nursecycle/core/colorconfig.dart';
import 'package:nursecycle/screens/auth/loginpage.dart';
import 'package:nursecycle/screens/auth/widgets/_textfields.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  _RegisterpageState createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  late final TextEditingController emailcontroller;
  late final TextEditingController usernamecontroller;
  late final TextEditingController passwordcontroller;
  bool obscurePassword = true;
  String selectedRole = 'nurse';
  bool _isLoading = false;

  @override
  void initState() {
    emailcontroller = TextEditingController();
    usernamecontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (emailcontroller.text.isEmpty ||
        passwordcontroller.text.isEmpty ||
        usernamecontroller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua kolom wajib diisi!")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
        data: {
          'username': usernamecontroller.text.trim(),
          'role': selectedRole,
        },
      );

      if (mounted) {
        if (response.session == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registrasi berhasil! Cek email untuk verifikasi."),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Loginpage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Akun berhasil dibuat!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Terjadi kesalahan tidak terduga"),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final paddingVertical = screenHeight * 0.02;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight,
            ),
            child: IntrinsicHeight(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: screenHeight * 0.42,
                    child: Image.asset("assets/images/bgsignup.png",
                        fit: BoxFit.cover),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.22,
                          ),
                          const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Image.asset("assets/images/pinkline.png"),
                          const Spacer(),
                          username(usernamecontroller),
                          SizedBox(height: paddingVertical),
                          email(emailcontroller),
                          SizedBox(height: paddingVertical),
                          const Text("Password",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          TextField(
                            controller: passwordcontroller,
                            obscureText: obscurePassword,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryColor, width: 2)),
                              hintText: "Masukkan Password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 20),
                                onPressed: () => setState(
                                    () => obscurePassword = !obscurePassword),
                              ),
                            ),
                          ),
                          SizedBox(height: paddingVertical),
                          const Text("Register as",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Nurse',
                                      style: TextStyle(fontSize: 14)),
                                  value: 'nurse',
                                  groupValue: selectedRole,
                                  activeColor: primaryColor,
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (val) =>
                                      setState(() => selectedRole = val!),
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Patient',
                                      style: TextStyle(fontSize: 14)),
                                  value: 'patient',
                                  groupValue: selectedRole,
                                  activeColor: primaryColor,
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (val) =>
                                      setState(() => selectedRole = val!),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: _isLoading ? null : _signUp,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2))
                                  : const Text("Create Account",
                                      style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account? "),
                              InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => const Loginpage())),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget username(TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Username",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      TTextField(
          controller: controller,
          label: "Username",
          hintText: "Masukkan username"),
    ],
  );
}

Widget email(TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Email",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      TTextField(
          controller: controller, label: "Email", hintText: "Masukkan email")
    ],
  );
}
