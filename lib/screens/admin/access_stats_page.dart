import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nursecycle/core/colorconfig.dart';

// Pastikan primaryColor sudah didefinisikan (misalnya di core/colorconfig.dart)

class AccessStatsPage extends StatefulWidget {
  const AccessStatsPage({super.key});

  @override
  State<AccessStatsPage> createState() => _AccessStatsPageState();
}

class _AccessStatsPageState extends State<AccessStatsPage> {
  final supabase = Supabase.instance.client;

  // Hanya menyimpan satu variabel: Total Akses
  late Future<int> _totalAccesses;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    setState(() {
      _totalAccesses = _fetchTotalAccesses();
    });
  }

  // Fungsi untuk menghitung TOTAL SEMUA baris di access_logs
  Future<int> _fetchTotalAccesses() async {
    try {
      // Query sederhana untuk menghitung semua baris di tabel
      final count = await supabase.from('access_logs').count(CountOption.exact);
      return count;
    } catch (e) {
      print('Error fetching total access count: $e');
      return 0;
    }
  }

  // Helper widget untuk kartu statistik (sama seperti sebelumnya)
  Widget _buildStatCard({
    required Future<int> futureCount,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 4),
                  FutureBuilder<int>(
                    future: futureCount,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LinearProgressIndicator();
                      }
                      final count = snapshot.data ?? 0;
                      return Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Statistik Akses",
            style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadStats,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ringkasan Data Akses Aplikasi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // --- KARTU TOTAL AKSES SAJA ---
            _buildStatCard(
              futureCount: _totalAccesses,
              label: "Total Keseluruhan Akses",
              icon: Icons.login_rounded,
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
