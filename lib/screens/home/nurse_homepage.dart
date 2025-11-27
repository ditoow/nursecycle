import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nursecycle/core/colorconfig.dart'; // Asumsi primaryColor
import 'package:nursecycle/screens/chat/chatqueuepage.dart';

class NurseHomePage extends StatefulWidget {
  const NurseHomePage({super.key});

  @override
  State<NurseHomePage> createState() => _NurseHomePageState();
}

class _NurseHomePageState extends State<NurseHomePage> {
  // Fungsi untuk mengambil statistik real dari DB
  Future<Map<String, String>> _fetchStats() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return {'queue': '-', 'handled': '-', 'patients': '-'};

    try {
      // Jalankan 3 query sekaligus (Parallel) biar cepat
      final results = await Future.wait([
        // 1. ANTRIAN: Status open DAN belum ada yang klaim (assigned_to_id IS NULL)
        Supabase.instance.client
            .from('chat_rooms')
            .count(CountOption.exact)
            .eq('status', 'open')
            .filter('assigned_to_id', 'is', null),

        // 2. DITANGANI: Status open DAN diklaim oleh saya
        Supabase.instance.client
            .from('chat_rooms')
            .count(CountOption.exact)
            .eq('status', 'open')
            .eq('assigned_to_id', user.id),

        // 3. TOTAL PASIEN: Hitung user dengan role 'patient'
        Supabase.instance.client
            .from('profiles')
            .count(CountOption.exact)
            .eq('role', 'patient'),
      ]);

      return {
        'queue': results[0].toString(),
        'handled': results[1].toString(),
        'patients': results[2].toString(),
      };
    } catch (e) {
      return {'queue': '0', 'handled': '0', 'patients': '0'};
    }
  }

  Future<void> _signOut(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    // Ambil nama dari metadata, fallback ke email
    final nurseName = user?.userMetadata?['username'] ??
        user?.email?.split('@')[0] ??
        'Perawat';

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
                radius: 18,
                backgroundColor: Colors.white,
                child:
                    Icon(Icons.medical_services, color: primaryColor, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello $nurseName",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Nurse • Online",
                  style: TextStyle(
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
          // Tombol Refresh Manual (Opsional)
          IconButton(
            onPressed: () {
              setState(() {}); // Rebuild untuk fetch ulang data
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
          IconButton(
              onPressed: () => _signOut(context),
              icon: const Icon(Icons.logout, color: Colors.white, size: 28)),
        ],
      ),
      body: Column(
        children: [
          // --- HEADER GRADIENT SECTION ---
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
                    "🏥 Dashboard Tugas",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tanggal: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- STATISTIK CARD (DATA DARI DATABASE) ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    // Gunakan FutureBuilder untuk memuat data
                    child: FutureBuilder<Map<String, String>>(
                      future: _fetchStats(),
                      builder: (context, snapshot) {
                        // Default values (Loading / 0)
                        String antrian = '-';
                        String ditangani = '-';
                        String totalPasien = '-';

                        if (snapshot.hasData) {
                          antrian = snapshot.data!['queue']!;
                          ditangani = snapshot.data!['handled']!;
                          totalPasien = snapshot.data!['patients']!;
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                                "Antrian", antrian, Icons.people_outline),
                            _buildStatItem("Ditangani", ditangani,
                                Icons.check_circle_outline),
                            // ✅ Diganti jadi Total Pasien
                            _buildStatItem("Total Pasien", totalPasien,
                                Icons.groups_outlined),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- ISI UTAMA: DAFTAR ANTRIAN ---
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Text( // Judul ini bisa dihapus karena di dalam ChatQueuePage sudah ada pemisahan
                  //   'Antrian Konsultasi Baru',
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  // const SizedBox(height: 12),

                  // Menggunakan ChatQueuePage
                  const Expanded(
                    child: ChatQueuePage(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
