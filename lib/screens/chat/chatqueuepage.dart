import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:nursecycle/screens/chat/chatpage.dart';

class ChatQueuePage extends StatefulWidget {
  const ChatQueuePage({super.key});

  @override
  State<ChatQueuePage> createState() => _ChatQueuePageState();
}

class _ChatQueuePageState extends State<ChatQueuePage> {
  final supabase = Supabase.instance.client;
  String? currentNurseId;

  @override
  void initState() {
    super.initState();
    currentNurseId = supabase.auth.currentUser?.id;
  }

  // --- FUNGSI KLAIM CHAT ---
  Future<void> _claimChat(String roomId) async {
    if (currentNurseId == null) return;

    try {
      await supabase.from('chat_rooms').update({
        'assigned_to_id': currentNurseId,
      }).eq('id', roomId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chat berhasil diklaim!')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengklaim chat: $error')),
        );
      }
    }
  }

  Stream<List<Map<String, dynamic>>> _getChatRoomsStream() {
    if (currentNurseId == null) {
      return const Stream.empty();
    }

    final initialQuery = supabase
        .from('chat_rooms')
        .select('*, patient:profiles!chat_rooms_patient_id_fkey(username)')
        .eq('status', 'open')
        .order('last_message_at', ascending: false);

    final realtimeStream = supabase
        .from('chat_rooms')
        .stream(primaryKey: ['id']).eq('status', 'open');

    return realtimeStream.asyncMap((event) async {
      final response = await initialQuery.limit(10);
      return response.cast<Map<String, dynamic>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Kita tidak perlu Scaffold/AppBar lagi karena sudah ada di NurseHomePage
    // Langsung kembalikan StreamBuilder
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _getChatRoomsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('Belum ada data konsultasi.',
                  style: TextStyle(color: Colors.grey)));
        }

        final allRooms = snapshot.data!;

        // 1. FILTER: Antrian Baru (Belum ada yang klaim)
        final newQueue =
            allRooms.where((room) => room['assigned_to_id'] == null).toList();

        // 2. FILTER: Chat Saya (Diklaim oleh perawat ini)
        final myChats = allRooms
            .where((room) => room['assigned_to_id'] == currentNurseId)
            .toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.only(
              bottom: 80), // Spasi bawah agar tidak tertutup
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === BAGIAN 1: CHAT SAYA (YANG SUDAH DI-CLAIM) ===
              if (myChats.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Chat Aktif Saya",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ),
                ...myChats
                    .map((room) => _buildChatTile(room, isMyChat: true))
                    .toList(),
                const SizedBox(height: 20), // Jarak antar seksi
              ],

              // === BAGIAN 2: ANTRIAN BARU (BELUM DI-CLAIM) ===
              if (newQueue.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Antrian Konsultasi Baru",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent),
                  ),
                ),
                ...newQueue
                    .map((room) => _buildChatTile(room, isMyChat: false))
                    .toList(),
              ] else if (myChats.isEmpty) ...[
                // Jika kedua list kosong
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(child: Text("Tidak ada antrian saat ini.")),
                )
              ],
            ],
          ),
        );
      },
    );
  }

  // --- WIDGET HELPER UNTUK MEMBUAT TILE/KARTU ---
  Widget _buildChatTile(Map<String, dynamic> room, {required bool isMyChat}) {
    final patientName =
        (room['patient'] as Map<String, dynamic>)['username'] ?? 'Pasien';

    // Parsing waktu
    final lastMessageTime = room['last_message_at'] != null
        ? DateTime.parse(room['last_message_at'])
        : DateTime.parse(room['created_at']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor:
                isMyChat ? Colors.blue.shade50 : Colors.red.shade50,
            child: Icon(
              Icons.person,
              color: isMyChat ? Colors.blue : Colors.red,
            ),
          ),
          const SizedBox(width: 12),

          // Info Nama & Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patientName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  isMyChat ? "Sedang menangani" : "Menunggu perawat...",
                  style: TextStyle(
                    fontSize: 12,
                    color: isMyChat ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Tombol Aksi (Klaim vs Lihat) & Waktu
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Menampilkan Waktu (misal: 5m ago)
              Text(
                timeago.format(lastMessageTime, locale: 'en_short'),
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const SizedBox(height: 6),

              // LOGIKA TOMBOL
              if (isMyChat)
                // Jika Chat Saya -> Tombol "Lihat" (Navigasi)
                SizedBox(
                  height: 30,
                  child: OutlinedButton(
                    onPressed: () => _openChat(room, patientName),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text("Lihat",
                        style: TextStyle(fontSize: 12, color: Colors.blue)),
                  ),
                )
              else
                // Jika Antrian Baru -> Tombol "Klaim"
                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () => _claimChat(room['id'] as String),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B9D), // Pink Primary
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text("Klaim",
                        style: TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  // Helper untuk membuka halaman chat
  void _openChat(Map<String, dynamic> room, String patientName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chatpage(
          roomId: room['id'] as String,
          receiverName: patientName,
          isNurseView: true,
        ),
      ),
    );
  }
}
