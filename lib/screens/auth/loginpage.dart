import 'package:flutter/material.dart';
import 'package:nursecycle/core/colorconfig.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nursecycle/screens/mainpage.dart';
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

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Melakukan login dengan Email dan Password
      await Supabase.instance.client.auth.signInWithPassword(
        email: identifiercontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );
    } on AuthException catch (e) {
      // Error spesifik dari Supabase (misal: password salah)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Error umum lainnya
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
                    "Sign In",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Image.asset("assets/images/pinkline.png"),
                  SizedBox(height: 36),
                  identifier(identifiercontroller),
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
                  SizedBox(height: screenHeight * 0.276),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          primaryColor, // Pastikan primaryColor terdefinisi
                      foregroundColor: Colors.white,
                      minimumSize: Size(screenHeight, 48),
                      elevation: 4,
                      fixedSize: const Size(274, 48),
                    ),
                    // Jika loading, disable tombol (null)
                    onPressed: _isLoading ? null : _signIn,
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
                            "Login",
                            style: TextStyle(fontSize: 14),
                          ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Dont have an Account?"),
                      SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Registerpage()));
                        },
                        child: Text(
                          "Register",
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
      ttextfield(
        controller: controller,
        label: "Username / Email",
        hintText: "Masukkan username atau email",
      ),
    ],
  );
}
