import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nursecycle/core/colorconfig.dart';
import 'package:nursecycle/screens/chat/patient_chat_menu.dart';
import 'package:nursecycle/screens/home/widgets/kalenderhaid.dart';
import 'package:nursecycle/screens/report/report_page.dart';
import 'package:nursecycle/screens/screening/identitasremaja.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // bool _isStartingChat = false;
  String _userName = "Loading...";
  String _userAge = "--";
  String _userGender = "";

  Map<String, dynamic>? _latestHealthData;
  bool _hasHealthData = false;
  String _lastUpdateDate = "-";

  bool _isLoading = true;

  final List<Map<String, dynamic>> _dailyReminders = [
    {
      'text': 'Jangan lupa minum air putih 8 gelas hari ini! 💧',
      'color': Colors.blue
    },
    {
      'text': 'Istirahat yang cukup ya, tidur minimal 8 jam. 😴',
      'color': Colors.indigo
    },
    {
      'text': 'Ada keluhan? Yuk chat perawat sekarang. 👩‍⚕️',
      'color': Colors.green
    },
    {'text': 'Semangat hari ini! Kamu hebat! 💪', 'color': Colors.orange},
    {'text': 'Sudah makan buah dan sayur hari ini? 🍎🥦', 'color': Colors.red},
  ];

  late Map<String, dynamic> _todaysReminder;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _todaysReminder = _dailyReminders[Random().nextInt(_dailyReminders.length)];
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      // 1. AMBIL DATA IDENTITAS (Nama & Tgl Lahir)
      final identityRes = await Supabase.instance.client
          .from('screening_identity')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      // 2. AMBIL DATA ANTROPOMETRI TERAKHIR (Kesehatan)
      final healthRes = await Supabase.instance.client
          .from('screening_antropometri')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (mounted) {
        setState(() {
          // Set Identitas
          if (identityRes != null) {
            _userName = identityRes['full_name'] ?? "User";
            _userGender = identityRes['gender'] ?? "";
            if (identityRes['birth_date'] != null) {
              _userAge = _calculateAge(identityRes['birth_date']).toString();
            }
          } else {
            // Fallback ke metadata auth jika belum screening
            _userName =
                user.userMetadata?['username'] ?? user.email!.split('@')[0];
          }

          // Set Kesehatan
          if (healthRes != null) {
            _hasHealthData = true;
            _latestHealthData = healthRes;
            final date = DateTime.parse(healthRes['created_at']);
            _lastUpdateDate = DateFormat('d MMM yyyy').format(date);
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading dashboard: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int _calculateAge(String birthDateString) {
    DateTime birthDate = DateTime.parse(birthDateString);
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  final List<String> healthData = [
    'Tidak ada keluhan',
    'Tekanan darah: Normal',
    'Suhu tubuh: 36.5°C',
    'Nadi: 80 bpm',
  ];

  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      // AuthGate akan mendeteksi perubahan state dan mengarahkan ke LoginPage
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal logout: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Siapkan Data Kesehatan untuk ditampilkan di Card Merah
    List<String> healthList = [];

    if (_hasHealthData && _latestHealthData != null) {
      final data = _latestHealthData!;
      healthList = [
        data['status_gizi'] != null
            ? 'Status Gizi: ${data['status_gizi']}'
            : 'Status Gizi: -',
        data['blood_pressure'] != null
            ? 'Tekanan darah: ${data['blood_pressure']}'
            : 'Tekanan darah: -',
        data['pulse_rate'] != null
            ? 'Nadi: ${data['pulse_rate']} bpm'
            : 'Nadi: -',
        data['chronic_disease'] != null && data['chronic_disease'] != ''
            ? 'Riwayat: ${data['chronic_disease']}'
            : 'Tidak ada keluhan kronis',
      ];
    } else {
      healthList = [
        'Data belum tersedia',
        'Silakan isi kuisioner',
        'untuk melihat riwayat',
        'kesehatan Anda disini.'
      ];
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: primaryColor),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // Nama Dinamis
                  "Hello ${_userName.split(' ')[0]}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  // Info Dinamis
                  _userAge == "--"
                      ? "Pasien Baru"
                      : "$_userGender • $_userAge tahun",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ],
            )
          ],
        ),
        actions: [
          // Notifikasi Dummy
          // Stack(
          //   children: [
          //     IconButton(
          //       onPressed: () {},
          //       icon: const Icon(Icons.notifications_outlined,
          //           color: Colors.white, size: 28),
          //     ),
          //     Positioned(
          //       right: 8,
          //       top: 8,
          //       child: Container(
          //         padding: const EdgeInsets.all(4),
          //         decoration: const BoxDecoration(
          //             color: Colors.red, shape: BoxShape.circle),
          //         constraints:
          //             const BoxConstraints(minWidth: 16, minHeight: 16),
          //         child: const Text('3',
          //             style: TextStyle(
          //                 color: Colors.white,
          //                 fontSize: 10,
          //                 fontWeight: FontWeight.bold),
          //             textAlign: TextAlign.center),
          //       ),
          //     ),
          //   ],
          // ),
          // Tombol Logout
          IconButton(
              onPressed: _signOut,
              icon: const Icon(Icons.logout, color: Colors.white, size: 28)),
          const SizedBox(width: 8),
        ],
      ),

      // Wrap dengan RefreshIndicator agar user bisa pull-to-refresh data dashboard
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Tampilkan loading jika true
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Header Section with Gradient
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "🩺 Riwayat Kesehatan",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              // Tanggal Update Dinamis
                              _hasHealthData
                                  ? "Terakhir Update: $_lastUpdateDate"
                                  : "Belum ada data",
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white70),
                            ),
                            const SizedBox(height: 16),

                            // Health Status List (Dinamis)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: healthList.map((item) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.check_circle,
                                            color: Colors.white, size: 16),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Main Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Aksi Cepat',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              // Tombol Isi Kuisioner
                              Expanded(
                                child: _buildQuickActionCard(
                                  icon: Icons.edit_note,
                                  label: 'Isi Kuisioner',
                                  color: Colors.blue,
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Identitasremaja())).then((_) =>
                                      _loadDashboardData()), // Refresh saat kembali
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Tombol Konsultasi (Chat)
                              Expanded(
                                child: _buildQuickActionCard(
                                  icon: Icons.chat_bubble_outline,
                                  label: 'Konsultasi',
                                  color: Colors.green,
                                  // ✅ GANTI DENGAN NAVIGASI INI:
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PatientChatMenu(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Tombol Laporan
                              Expanded(
                                child: _buildQuickActionCard(
                                  icon: Icons.description_outlined,
                                  label: 'Laporan',
                                  color: Colors.purple,
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ReportPage())),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          // Kalender Haid Card
                          const KalenderHaid(),

                          const SizedBox(height: 16),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header Kecil
                                  Row(
                                    children: [
                                      Icon(Icons.campaign,
                                          color: _todaysReminder['color'],
                                          size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Pengingat Harian",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Isi Pesan
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: (_todaysReminder['color'] as Color)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: (_todaysReminder['color']
                                                  as Color)
                                              .withValues(alpha: 0.3),
                                          width: 1),
                                    ),
                                    child: Text(
                                      _todaysReminder['text'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            (_todaysReminder['color'] as Color)
                                                .withValues(alpha: 0.9),
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Helper Widget untuk Aksi Cepat agar kode lebih bersih
  Widget _buildQuickActionCard(
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 110,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
