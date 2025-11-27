import 'package:flutter/material.dart';
import 'package:nursecycle/core/colorconfig.dart';
// import 'package:nursecycle/models/chatmessage.dart';
import 'package:nursecycle/screens/chat/widgets/attachment.dart';
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

  Future<void> _sendMessage() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || _messageController.text.trim().isEmpty) return;

    // Ambil ID perawat/pasien dari user yang sedang login
    final senderId = user.id;

    final messageText = _messageController.text.trim();
    _messageController.clear(); // Hapus pesan segera

    // Reset state untuk mematikan tombol send (opsional)
    if (mounted) setState(() {});

    try {
      await Supabase.instance.client.from('chat_messages').insert({
        'room_id': widget.roomId,
        'sender_id': senderId,
        'content': messageText,
        // 'is_read': false, (Akan diupdate oleh receiver)
      });

      // Opsional: Update last_message_at di chat_rooms
      await Supabase.instance.client
          .from('chat_rooms')
          .update({'last_message_at': DateTime.now().toIso8601String()}).eq(
              'id', widget.roomId);
    } catch (e) {
      if (mounted) {
        // Tampilkan error jika gagal kirim ke DB
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal kirim pesan: ${e.toString()}')));
      }
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
  }

  @override
  void dispose() {
    // ✅ 3. Dispose hanya untuk bersih-bersih controller
    _messageController.dispose();
    _scrollController.dispose();
    // (Jangan ada inisialisasi stream di sini)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    if (_messagesStream == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin Kesehatan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
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
                        title: const Text('Info Admin'),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_outline),
                        title: const Text('Hapus Chat'),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.block),
                        title: const Text('Blokir'),
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Mulai percakapan baru.'));
                }

                final messages = snapshot.data!;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
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
                              DateTime.parse(message['created_at']))
                          .format(context),
                      // isFromAdmin ditentukan berdasarkan role pengirim vs current user
                      isFromAdmin: widget.isNurseView
                          ? !senderIsCurrentUser
                          : !senderIsCurrentUser,
                      primaryColor: primaryColor,
                      // ...
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.grey),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Kirim File',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Attachment(
                                      icon: Icons.photo,
                                      label: 'Galeri',
                                      color: Colors.purple,
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    Attachment(
                                      icon: Icons.camera_alt,
                                      label: 'Kamera',
                                      color: Colors.blue,
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    Attachment(
                                      icon: Icons.insert_drive_file,
                                      label: 'Dokumen',
                                      color: Colors.orange,
                                      onTap: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
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
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
