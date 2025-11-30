import 'package:flutter/material.dart';
import 'package:nursecycle/core/colorconfig.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:nursecycle/screens/chat/chatpage.dart';

class ChatQueuePage extends StatefulWidget {
  final bool isEmbedded;
  const ChatQueuePage({super.key, this.isEmbedded = false});

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
    return Scaffold(
      backgroundColor: Colors.grey[50], // Background bersih
      // Kita menggunakan Column untuk Header + List
      body: Column(
        children: [
          if (!widget.isEmbedded)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Antrian Konsultasi",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(height: 8),
                      Text("Kelola chat pasien yang masuk",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ),

          // --- 2. ISI LIST (StreamBuilder) ---
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _getChatRoomsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mark_chat_read_outlined,
                            size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text("Tidak ada antrian chat",
                            style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  );
                }

                final allRooms = snapshot.data!;
                final newQueue = allRooms
                    .where((room) => room['assigned_to_id'] == null)
                    .toList();
                final myChats = allRooms
                    .where((room) => room['assigned_to_id'] == currentNurseId)
                    .toList();

                if (newQueue.isEmpty && myChats.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.done_all, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text("Semua chat sudah tertangani",
                            style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // === BAGIAN 1: CHAT SAYA ===
                    if (myChats.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12, left: 4),
                        child: Text(
                          "Chat Aktif Saya",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      ...myChats
                          .map((room) => _buildChatTile(room, isMyChat: true)),
                      const SizedBox(height: 24),
                    ],

                    // === BAGIAN 2: ANTRIAN BARU ===
                    if (newQueue.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12, left: 4),
                        child: Row(
                          children: [
                            const Text(
                              "Antrian Baru",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Text(
                                "${newQueue.length}",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      ...newQueue
                          .map((room) => _buildChatTile(room, isMyChat: false)),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
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
            color: Colors.grey.withValues(alpha: 0.1),
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
