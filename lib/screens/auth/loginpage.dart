// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:nursecycle/core/colorconfig.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:nursecycle/screens/mainpage.dart';
import 'package:nursecycle/screens/auth/registerpage.dart';
import 'package:nursecycle/screens/auth/widgets/_textfields.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  LoginpageState createState() => LoginpageState();
}

class LoginpageState extends State<Loginpage> {
  late final TextEditingController identifiercontroller;
  late final TextEditingController passwordcontroller;
  bool obscurePassword = true;
  // String selectedRole = 'nurse';

  bool _isLoading = false;

  @override
  void initState() {
    identifiercontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    identifiercontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  Future<void> _logUserAccess() async {
    try {
      // INSERT KOSONG: Hanya mencatat waktu. user_id diabaikan.
      await Supabase.instance.client.from('access_logs').insert({});
    } catch (e) {
      print('Gagal mencatat log akses: $e');
    }
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Login ke Supabase
      await Supabase.instance.client.auth.signInWithPassword(
        email: identifiercontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );

      // 2. ✅ TAMBAHAN WAJIB: Cek & Buat Profile (Fallback karena Trigger mati)
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        // Cek apakah data profile sudah ada
        final profileCheck = await Supabase.instance.client
            .from('profiles')
            .select('id')
            .eq('id', user.id)
            .maybeSingle();

        // Jika Profile TIDAK ADA, buat secara manual sekarang
        if (profileCheck == null) {
          // Ambil nama dari metadata (jika ada) atau dari email
          final username =
              user.userMetadata?['username'] ?? user.email!.split('@')[0];
          final role =
              user.userMetadata?['role'] ?? 'patient'; // Default patient

          await Supabase.instance.client.from('profiles').insert({
            'id': user.id,
            'username': username,
            'role': role,
            'full_name': username, // Fallback full_name
            'created_at': DateTime.now().toIso8601String(),
          });
        }
      }

      if (mounted) {
        // ✅ HANYA TAMPILKAN SNACKBAR. JANGAN NAVIGASI.
        // AuthGate akan mendeteksi sesi baru secara otomatis.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Berhasil!")),
        );
      }
      await _logUserAccess();
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
            content: Text("Terjadi kesalahan tidak terduga."),
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
    final paddingVertical = screenHeight * 0.02;

    return GestureDetector(
      onTap: () =>
          FocusScope.of(context).unfocus(), // Tutup keyboard saat tap luar
      child: Scaffold(
        // ✅ Izinkan resize agar keyboard tidak menutupi input
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            // ✅ Pastikan container minimal setinggi layar
            constraints: BoxConstraints(
              minHeight: screenHeight,
            ),
            child: IntrinsicHeight(
              child: Stack(
                children: [
                  // Background Image
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: screenHeight * 0.42,
                    child: Image.asset("assets/images/bgsignup.png",
                        fit: BoxFit.cover),
                  ),

                  // Content
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- BAGIAN ATAS (Title & Form) ---
                          SizedBox(height: screenHeight * 0.22),
                          const Text(
                            "Sign In",
                            style: TextStyle(
                                fontSize: 38, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Image.asset("assets/images/pinkline.png"),

                          // ✅ Gunakan Spacer untuk mendorong form ke tengah
                          SizedBox(height: screenHeight * 0.05),

                          identifier(identifiercontroller),
                          SizedBox(height: paddingVertical),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Password",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                child: TextField(
                                  controller: passwordcontroller,
                                  obscureText: obscurePassword,
                                  style: const TextStyle(fontSize: 14),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 14),
                                    border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primaryColor),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: primaryColor, width: 2),
                                    ),
                                    // Pastikan TTextField juga pakai focusColor ini
                                    focusColor: primaryColor,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    hintText: "Masukkan Password",
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: 20, // Samakan ukuran icon
                                      ),
                                      onPressed: () => setState(() =>
                                          obscurePassword = !obscurePassword),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // ✅ Gunakan Spacer lagi untuk mendorong tombol ke bawah
                          const Spacer(),

                          // --- BAGIAN BAWAH (Tombol Login) ---
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
                              onPressed: _isLoading ? null : _signIn,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2))
                                  : const Text("Login",
                                      style: TextStyle(fontSize: 16)),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Register Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Dont have an Account?"),
                              const SizedBox(width: 4),
                              InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => const Registerpage())),
                                child: Text("Register",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24), // Padding bawah aman
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

Widget identifier(TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Username / Email",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 8),
      TTextField(
        controller: controller,
        label: "Username / Email",
        hintText: "Masukkan username atau email",
      ),
    ],
  );
}
