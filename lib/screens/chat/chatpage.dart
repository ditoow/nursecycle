import 'package:flutter/material.dart';
import 'package:nursecycle/core/colorconfig.dart';
// import 'package:nursecycle/models/chatmessage.dart';
// import 'package:nursecycle/screens/chat/widgets/attachment.dart';
import 'package:nursecycle/screens/chat/widgets/chatbubble.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Chatpage extends StatefulWidget {
  final String roomId;
  final String receiverName;
  final bool isNurseView; // Flag: apakah ini dilihat dari sisi perawat?

  const Chatpage({
    super.key,
    required this.roomId,
    required this.receiverName,
    required this.isNurseView,
  });

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Stream<List<Map<String, dynamic>>>? _messagesStream;
  Stream<Map<String, dynamic>>? _roomStream;

  Future<void> _sendMessage({String? textOverride}) async {
    final text = textOverride ?? _messageController.text.trim();
    if (text.isEmpty) return;

    if (textOverride == null) _messageController.clear();

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      // --- LOGIKA TIMEOUT (Auto-Reset) ---
      // Hanya jalan di sisi Pasien
      if (!widget.isNurseView) {
        debugPrint("🔍 [DEBUG] Cek Timeout dimulai...");

        // 1. Ambil data room
        final roomCheck = await Supabase.instance.client
            .from('chat_rooms')
            .select('last_message_at')
            .eq('id', widget.roomId)
            .single();

        final lastMessageTimeStr = roomCheck['last_message_at'] as String?;
        debugPrint(
            "🔍 [DEBUG] Waktu pesan terakhir di DB: $lastMessageTimeStr");

        if (lastMessageTimeStr != null) {
          // Parsing waktu (Pastikan timezone-nya benar, biasanya UTC)
          final lastTime = DateTime.parse(lastMessageTimeStr)
              .toLocal(); // Convert ke waktu HP
          final now = DateTime.now();
          final difference = now.difference(lastTime).inMinutes;

          // SETTING WAKTU TIMEOUT (Misal: 1 Menit untuk tes)
          const int timeoutMinutes = 1;

          debugPrint("🔍 [DEBUG] Waktu Sekarang: $now");
          debugPrint("🔍 [DEBUG] Selisih waktu: $difference menit");
          debugPrint("🔍 [DEBUG] Batas Timeout: $timeoutMinutes menit");

          if (difference >= timeoutMinutes) {
            debugPrint("⚠️ [DEBUG] TIMEOUT TERDETEKSI! Mereset room...");

            // JIKA BASI: Reset Room
            await Supabase.instance.client.from('chat_rooms').update({
              'assigned_to_id': null,
              'is_bot_active': true,
              'bot_step': null,
              'status': 'open',
            }).eq('id', widget.roomId);

            await _sendBotMessage(
                "⏳ Sesi sebelumnya telah berakhir otomatis karena tidak ada aktivitas.");
          } else {
            debugPrint("✅ [DEBUG] Masih dalam durasi sesi aktif.");
          }
        } else {
          debugPrint(
              "ℹ️ [DEBUG] Belum ada last_message_at (Chat pertama/baru).");
        }
      }
      // ------------------------------------------------

      // 2. KIRIM PESAN USER
      debugPrint("📤 [DEBUG] Mengirim pesan user...");
      await Supabase.instance.client.from('chat_messages').insert({
        'room_id': widget.roomId,
        'sender_id': user.id,
        'content': text,
      });

      // 3. TRIGGER LOGIKA BOT
      if (!widget.isNurseView) {
        debugPrint("🤖 [DEBUG] Memanggil otak bot (_handleBotLogic)...");
        await _handleBotLogic(text);
      }
    } catch (e) {
      debugPrint("❌ [DEBUG ERROR] : $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _handleBotLogic(String userMessage) async {
    // 1. Ambil status room terbaru
    final roomData = await Supabase.instance.client
        .from('chat_rooms')
        .select('status, is_bot_active, bot_step')
        .eq('id', widget.roomId)
        .single();

    final status = roomData['status'] as String;
    final isBotActive = roomData['is_bot_active'] as bool? ?? true;
    final botStep = roomData['bot_step'] as String?;

    // --- SKENARIO A: ROOM SUDAH TUTUP (RE-OPEN) ---
    if (status == 'resolved') {
      await _updateRoomState(
          status: 'open', isBotActive: true, step: 'OPENING', assignedTo: null);
      await _sendBotMessage(
          "Halo kembali! 👋 Sesi sebelumnya sudah selesai. Ada keluhan baru yang bisa saya bantu catat?");
      return;
    }

    // Jika Bot TIDAK AKTIF (sedang ditangani perawat), stop di sini.
    if (!isBotActive) return;

    // --- SKENARIO B: LOGIKA TRIASE (BOT STEP BY STEP) ---

    // 1. Inisiasi (Chat Pertama di Room Baru)
    if (botStep == null) {
      await _updateRoomState(step: 'OPENING');
      await _sendBotMessage(
          "Selamat datang di Layanan Bantuan Sayabini. 😊\nPerawat kami mungkin sedang sibuk, saya akan membantu mendata keluhan Anda terlebih dahulu.\n\nApa yang Anda rasakan?");
    }

    // 2. User Menjawab Sapaan/Gejala Awal -> Masuk ke Triase Merah
    else if (botStep == 'OPENING') {
      await _updateRoomState(step: 'TRIAGE_RED_1');
      await _sendBotMessage(
          "Baik. Saya perlu menanyakan beberapa hal penting.\n\n⚠️ Apakah Anda mengalami sesak napas berat, nyeri dada hebat, atau pendarahan yang tidak berhenti?");
    }

    // 3. Triase Merah (Darurat)
    else if (botStep == 'TRIAGE_RED_1') {
      if (userMessage.toLowerCase() == 'ya') {
        // HASIL MERAH: STOP BOT, SARANKAN IGD
        await _updateRoomState(
            isBotActive: false, step: 'DONE_URGENT'); // Matikan bot
        await _sendBotMessage(
            "🚨 PERHATIAN: Gejala ini termasuk tanda bahaya!\n\nMohon SEGERA ke IGD terdekat untuk penanganan medis langsung. Saya telah menandai pesan ini sebagai Prioritas Tinggi.");
      } else {
        // LANJUT KE KUNING
        await _updateRoomState(step: 'TRIAGE_YELLOW_1');
        await _sendBotMessage(
            "Baik. Selanjutnya, apakah Anda mengalami demam tinggi (>38.5°C) atau nyeri yang sangat mengganggu aktivitas?");
      }
    }

    // 4. Triase Kuning (Perlu Perhatian)
    else if (botStep == 'TRIAGE_YELLOW_1') {
      if (userMessage.toLowerCase() == 'ya') {
        // HASIL KUNING: STOP BOT, MENUNGGU PERAWAT
        await _updateRoomState(isBotActive: false, step: 'DONE_PRIORITY');
        await _sendBotMessage(
            "Terima kasih informasinya. Keluhan Anda perlu evaluasi lebih lanjut.\n\nSaya sudah meneruskan ini ke perawat. Mohon tunggu sebentar, perawat akan segera merespons. ⏳");
      } else {
        // LANJUT KE HIJAU
        await _updateRoomState(step: 'TRIAGE_GREEN_1');
        await _sendBotMessage(
            "Apakah keluhan ini sudah berlangsung lebih dari 3 hari?");
      }
    }

    // 5. Triase Hijau (Ringan/Edukasi)
    else if (botStep == 'TRIAGE_GREEN_1') {
      // Apapun jawabannya, kita berikan edukasi umum
      await _updateRoomState(isBotActive: false, step: 'DONE_NORMAL');
      await _sendBotMessage(
          "Baik. Sepertinya kondisi Anda stabil. ✅\n\nSaran awal: Istirahat cukup, minum banyak air putih, dan pantau gejala.\nJika memburuk, segera kabari kami lagi. Perawat akan mengecek pesan ini segera.");
    }
  }

  // Helper untuk update status room biar kodenya rapi
  Future<void> _updateRoomState({
    String? status,
    bool? isBotActive,
    String? step,
    String? assignedTo, // Pass null to clear assignment
  }) async {
    final Map<String, dynamic> updates = {
      'last_message_at': DateTime.now().toIso8601String(),
    };
    if (status != null) updates['status'] = status;
    if (isBotActive != null) updates['is_bot_active'] = isBotActive;
    if (step != null) updates['bot_step'] = step;
    // Khusus untuk assigned_to, kita perlu logika khusus jika ingin set NULL
    // Tapi untuk simplifikasi di method ini, kita asumsikan jika dipanggil dengan null, berarti reset.
    if (assignedTo == null && status == 'open')
      updates['assigned_to_id'] = null;

    await Supabase.instance.client
        .from('chat_rooms')
        .update(updates)
        .eq('id', widget.roomId);
  }

  // Helper untuk pesan bot (Sama seperti sebelumnya)
  Future<void> _sendBotMessage(String text) async {
    await Supabase.instance.client.from('chat_messages').insert({
      'room_id': widget.roomId,
      'sender_id': '7e1a2375-58c4-4f9a-a305-826c8576c605',
      'content': text,
    });
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Info Perawat"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.pink,
              child:
                  Icon(Icons.medical_services, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 16),
            Text(widget.receiverName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Text("Perawat Jaga", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            const Text(
              "Perawat berlisensi yang siap membantu keluhan kesehatan remaja Anda.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  Future<void> _clearMessagesFromDB() async {
    await Supabase.instance.client
        .from('chat_messages')
        .delete()
        .eq('room_id', widget.roomId);
  }

  Future<void> _deleteChatHistory() async {
    // 1. Dialog Konfirmasi
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Chat?"),
        content: const Text("Riwayat percakapan ini akan dihapus permanen."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Hapus", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      // ✅ PANGGIL FUNGSI HELPER
      await _clearMessagesFromDB();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Riwayat chat dihapus.")));
        Navigator.pop(context); // Kembali
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Gagal hapus: $e")));
    }
  }

  Future<void> _endSession() async {
    // 1. Dialog Konfirmasi
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Akhiri Konsultasi?"),
        content: const Text("Chat akan dihapus dan sesi diakhiri."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Akhiri", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      // ✅ 2. PANGGIL FUNGSI HELPER (Reuse Logic Hapus)
      // await _clearMessagesFromDB();

      // 3. Reset Room (Logic khusus End Session)
      await Supabase.instance.client.from('chat_rooms').update({
        'status':
            'open', // ✅ Ubah ke 'resolved' agar hilang dari antrian sementara
        'assigned_to_id': null, // ✅ Tendang perawat (Lepas klaim)
        'is_bot_active': true, // ✅ AKTIFKAN BOT LAGI
        'bot_step': null, // ✅ RESET INGATAN BOT (Biar mulai dari awal lagi)
      }).eq('id', widget.roomId);

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Sesi berakhir.")));
        Navigator.pop(context); // Kembali ke antrian
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Gagal: $e")));
    }
  }

  @override
  void initState() {
    super.initState();

    _messagesStream = Supabase.instance.client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', widget.roomId)
        .order('created_at', ascending: true);

    _roomStream = Supabase.instance.client
        .from('chat_rooms')
        .stream(primaryKey: ['id'])
        .eq('id', widget.roomId)
        .map((event) => event.first);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildQuickReplies(Map<String, dynamic> roomData) {
    final isBotActive = roomData['is_bot_active'] as bool? ?? false;
    final botStep = roomData['bot_step'] as String?;

    // Jika bot mati atau user adalah perawat, jangan tampilkan apa-apa
    if (!isBotActive || widget.isNurseView) return const SizedBox.shrink();

    // Tentukan Opsi Jawaban berdasarkan Step
    List<String> options = [];

    if (botStep == 'OPENING') {
      options = [
        'Demam',
        'Batuk & Pilek',
        'Nyeri Tubuh',
        'Masalah Kulit',
        'Lainnya'
      ];
    } else if (botStep != null &&
        (botStep.startsWith('TRIAGE') ||
            botStep.startsWith('RED_') ||
            botStep.startsWith('YELLOW_'))) {
      // Untuk semua pertanyaan Triase (Merah/Kuning/Hijau)
      options = ['Ya', 'Tidak'];
    }

    if (options.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final option = options[index];
          return ActionChip(
            label: Text(option),
            backgroundColor: Colors.white,
            side: BorderSide(color: primaryColor),
            labelStyle:
                TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
            onPressed: () {
              // Kirim pesan otomatis saat diklik
              _sendMessage(textOverride: option);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    if (_messagesStream == null || _roomStream == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.medical_services,
                color: Color(0xFFFF6B9D),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.receiverName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // ... (Logika BottomSheet Menu titik tiga tetap sama) ...
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text('Info Perawat'),
                        onTap: () {
                          Navigator.pop(context);
                          _showInfo();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_outline,
                            color: Colors.orange),
                        title: const Text('Hapus Riwayat Chat',
                            style: TextStyle(color: Colors.orange)),
                        onTap: () {
                          Navigator.pop(context);
                          _deleteChatHistory();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.check_circle_outline,
                            color: Colors.red),
                        title: const Text('Akhiri Konsultasi',
                            style: TextStyle(color: Colors.red)),
                        onTap: () {
                          Navigator.pop(context);
                          _endSession();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // ✅ 1. STREAM LUAR (Status Room/Bot)
      body: StreamBuilder<Map<String, dynamic>>(
        stream: _roomStream,
        builder: (context, roomSnapshot) {
          final roomData = roomSnapshot.data;

          return Column(
            children: [
              // ✅ 2. LIST MESSAGE
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _messagesStream,
                  builder: (context, msgSnapshot) {
                    if (msgSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!msgSnapshot.hasData || msgSnapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('Mulai percakapan baru.'));
                    }

                    final messages = msgSnapshot.data!;

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    });

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final senderIsCurrentUser =
                            message['sender_id'] == currentUserId;

                        return ChatBubble(
                          text: message['content'] as String,
                          time: TimeOfDay.fromDateTime(
                                  DateTime.parse(message['created_at'])
                                      .toLocal() // <--- INI KUNCINYA
                                  )
                              .format(context),
                          isFromAdmin: widget.isNurseView
                              ? !senderIsCurrentUser
                              : !senderIsCurrentUser,
                          primaryColor: primaryColor,
                        );
                      },
                    );
                  },
                ),
              ),

              // ✅ 3. QUICK REPLIES (Jika Bot Aktif)
              if (roomData != null) _buildQuickReplies(roomData),

              // ✅ 4. INPUT FIELD (STYLE TETAP SAMA / ASLI)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05), // opacity fix
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      // Tombol Tambah (Plus) - Style Asli
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.grey),
                          onPressed: () {
                            // Logika modal attachment (tetap sama)
                          },
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Input Teks - Style Asli (Rounded Grey)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Tulis pesan...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (value) => _sendMessage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Tombol Kirim - Style Asli (Pink Circle)
                      Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: () => _sendMessage(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
