import 'package:flutter/material.dart';
import 'package:nursecycle/screens/home/nurse_homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nursecycle/core/theme.dart';
import 'package:nursecycle/screens/auth/loginpage.dart';
import 'package:nursecycle/screens/mainpage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // Ganti dengan URL dan Anon Key dari Dashboard Supabase kamu
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NurseCycle',
      theme: AppTheme.lightTheme, // Asumsi kamu punya theme di core/theme.dart
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // 1. Loading saat inisialisasi auth
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final session = snapshot.data?.session;

        if (session != null) {
          // 2. User Login -> Cek Role di Database
          return FutureBuilder<Map<String, dynamic>>(
            future: Supabase.instance.client
                .from('profiles')
                .select('role')
                .eq('id', session.user.id)
                .single(),
            builder: (context, roleSnapshot) {
              // Loading saat fetch role
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }

              // Jika ada error atau data kosong, fallback ke Pasien (atau Error Page)
              if (roleSnapshot.hasError || !roleSnapshot.hasData) {
                // Opsional: Bisa logout paksa jika role tidak ketemu
                // Supabase.instance.client.auth.signOut();
                return const Mainpage();
              }

              final role = roleSnapshot.data!['role'] as String?;

              // 3. Routing Berdasarkan Role
              if (role == 'nurse') {
                return const NurseHomePage();
              } else {
                return const Mainpage(); // Pasien
              }
            },
          );
        } else {
          // 4. Belum Login -> Halaman Login
          return const Loginpage();
        }
      },
    );
  }
}
