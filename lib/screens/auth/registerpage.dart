import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nursecycle/core/colorconfig.dart';
import 'package:nursecycle/screens/auth/loginpage.dart';
import 'package:nursecycle/screens/auth/widgets/_textfields.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  RegisterpageState createState() => RegisterpageState();
}

class RegisterpageState extends State<Registerpage> {
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
    // Validasi input kosong sederhana
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

    final Map<String, dynamic> metadata = {
      'username': usernamecontroller.text.trim(),
      'role': selectedRole,
    };

    print('DEBUG: Checking registration payload...');
    print('Payload: $metadata');

    try {
// Mendaftar ke Supabase
      final response = await Supabase.instance.client.auth.signUp(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
        data: metadata, // ✅ GUNAKAN VARIABEL METADATA (Bukan membuat map baru)
      );

      if (mounted) {
        // Cek apakah butuh konfirmasi email atau tidak
        if (response.session == null) {
          // Jika Supabase setting "Enable Email Confirm" = ON
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registrasi berhasil! Cek email untuk verifikasi."),
              backgroundColor: Colors.green,
            ),
          );
          // Lempar ke halaman login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Loginpage()),
          );
        } else {
          // Jika Supabase setting "Enable Email Confirm" = OFF (Langsung login)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Akun berhasil dibuat!"),
              backgroundColor: Colors.green,
            ),
          );
          // Tidak perlu navigasi manual karena AuthGate di main.dart akan otomatis mendeteksi session baru
          // Tapi kita bisa pop halaman register ini agar stack bersih
          Navigator.of(context).pop();
        }
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Terjadi kesalahan tidak terduga"),
            backgroundColor: Colors.red,
          ),
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
    return Scaffold(
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: screenHeight * 0.42,
            child: Image.asset("assets/images/bgsignup.png", fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: screenHeight * 0.22),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Image.asset("assets/images/pinkline.png"),
                  SizedBox(height: 36),
                  username(usernamecontroller),
                  SizedBox(height: 24),
                  email(emailcontroller),
                  SizedBox(height: 24),
                  Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 32,
                    width: double.infinity,
                    child: TextField(
                      controller: passwordcontroller,
                      style: TextStyle(fontSize: 14),
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                        focusColor: primaryColor,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                        labelText: "Password",
                        labelStyle: TextStyle(fontSize: 14),
                        hintText: "Masukkan Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 16,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Register as",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text(
                            'Nurse',
                            style: TextStyle(fontSize: 14),
                          ),
                          value: 'nurse',
                          groupValue: selectedRole,
                          activeColor: primaryColor,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text(
                            'Patient',
                            style: TextStyle(fontSize: 14),
                          ),
                          value: 'patient',
                          groupValue: selectedRole,
                          activeColor: primaryColor,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          primaryColor, // Pastikan primaryColor ada
                      foregroundColor: Colors.white, // Warna text putih
                      minimumSize: Size(screenHeight, 48),
                      elevation: 4,
                      fixedSize: const Size(274, 48),
                    ),
                    onPressed: _isLoading ? null : _signUp,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Create Account",
                            style: TextStyle(fontSize: 14),
                          ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? "),
                      SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Loginpage()));
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget username(TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Username",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 8),
      ttextfield(
        controller: controller,
        label: "Username",
        hintText: "Masukkan username",
      ),
    ],
  );
}

Widget email(TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Email",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 8),
      ttextfield(
        controller: controller,
        label: "Email",
        hintText: "Masukkan email",
      )
    ],
  );
}
