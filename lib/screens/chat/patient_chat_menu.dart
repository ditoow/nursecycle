import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nursecycle/screens/chat/chatpage.dart';
import 'package:nursecycle/core/colorconfig.dart'; // Asumsi warna ada di sini

class PatientChatMenu extends StatefulWidget {
  const PatientChatMenu({super.key});

  @override
  State<PatientChatMenu> createState() => _PatientChatMenuState();
}

class _PatientChatMenuState extends State<PatientChatMenu> {
  bool _isLoading = false;

  // Fungsi logika yang sama dengan di Homepage, tapi diadaptasi untuk halaman ini
  Future<void> _handleStartChat() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      // 1. Cari room yang sudah ada
      final existingRoom = await Supabase.instance.client
          .from('chat_rooms')
          .select('id')
          .eq('patient_id', user.id)
          .maybeSingle();

      String roomId;

      if (existingRoom != null) {
        roomId = existingRoom['id'] as String;
      } else {
        // 2. Jika belum ada, buat baru
        final newRoom = await Supabase.instance.client
            .from('chat_rooms')
            .insert({
              'patient_id': user.id,
              'last_message_at': DateTime.now().toIso8601String(),
              'status': 'open',
            })
            .select('id')
            .single();
        roomId = newRoom['id'] as String;
      }

      if (mounted) {
        // Ke halaman chat
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chatpage(
              roomId: roomId,
              receiverName: 'Admin Kesehatan',
              isNurseView: false,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat chat: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Samakan background body

      // ✅ APP BAR YANG SUDAH DI-STYLING
      appBar: AppBar(
        backgroundColor: primaryColor, // Warna Pink
        elevation: 0,
        centerTitle: false, // Rata kiri (opsional, sesuaikan selera)

        // Tombol Back (Panah) jadi Putih
        iconTheme: const IconThemeData(color: Colors.white),

        title: const Text(
          'Konsultasi',
          style: TextStyle(
            color: Colors.white, // Teks Putih
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.support_agent_rounded,
              size: 100,
              color: primaryColor, // Sesuaikan primaryColor
            ),
            const SizedBox(height: 24),
            const Text(
              'Butuh bantuan kesehatan?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Hubungi perawat kami untuk konsultasi mengenai kesehatan reproduksi dan pubertas.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleStartChat,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, // Sesuaikan primaryColor
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat),
                        SizedBox(width: 10),
                        Text('Chat dengan Perawat',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
