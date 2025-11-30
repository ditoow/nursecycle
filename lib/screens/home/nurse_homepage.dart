import 'package:flutter/material.dart';
import 'package:nursecycle/screens/article/manage_articles_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nursecycle/core/colorconfig.dart'; // Asumsi primaryColor
import 'package:nursecycle/screens/chat/chatqueuepage.dart';

class NurseHomePage extends StatefulWidget {
  const NurseHomePage({super.key});

  @override
  State<NurseHomePage> createState() => _NurseHomePageState();
}

class _NurseHomePageState extends State<NurseHomePage> {
  // Fungsi statistik (sama seperti sebelumnya)
  Future<Map<String, String>> _fetchStats() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return {'queue': '-', 'handled': '-', 'patients': '-'};

    try {
      final results = await Future.wait([
        Supabase.instance.client
            .from('chat_rooms')
            .count(CountOption.exact)
            .eq('status', 'open')
            .filter('assigned_to_id', 'is', null),
        Supabase.instance.client
            .from('chat_rooms')
            .count(CountOption.exact)
            .eq('status', 'open')
            .eq('assigned_to_id', user.id),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello $nurseName",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    // Opsional: Tambahkan ellipsis biar rapi kalau nama sangaaat panjang
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ManageArticlesPage()));
            },
            icon: const Icon(Icons.edit_document,
                color: Colors.white), // Ikon artikel
            tooltip: "Kelola Artikel",
          ),
          IconButton(
            onPressed: () {
              setState(() {});
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
          // --- HEADER (Fixed Height) ---
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

                  // Statistik Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: FutureBuilder<Map<String, String>>(
                      future: _fetchStats(),
                      builder: (context, snapshot) {
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

          // --- ISI UTAMA: DAFTAR ANTRIAN (Expanded) ---
          // ✅ Expanded 1: Mengambil sisa ruang di layar (di bawah Header)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Expanded 2: Memaksa ChatQueuePage agar punya tinggi terbatas
                  // dan bisa di-scroll di dalamnya.
                  const Expanded(
                    child: ChatQueuePage(isEmbedded: true),
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
