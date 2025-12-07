class ChatRoom {
  final String id;
  final String patientId;
  final String? assignedToId;
  final String status; // 'open', 'resolved', etc.
  final DateTime lastMessageAt;
  final DateTime createdAt;

  // --- KOLOM BARU UNTUK BOT ---
  final bool isBotActive;
  final String? botStep; // 'OPENING', 'TRIAGE_RED_1', dll.

  // Helper: Nama pasien (dari hasil join, opsional)
  final String? patientName;

  ChatRoom({
    required this.id,
    required this.patientId,
    this.assignedToId,
    required this.status,
    required this.lastMessageAt,
    required this.createdAt,
    required this.isBotActive,
    this.botStep,
    this.patientName,
  });

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] as String,
      patientId: map['patient_id'] as String,
      assignedToId: map['assigned_to_id'] as String?,
      status: map['status'] as String? ?? 'open',

      // Parsing Tanggal dengan aman
      lastMessageAt: map['last_message_at'] != null
          ? DateTime.parse(map['last_message_at'])
          : DateTime.parse(map['created_at']),
      createdAt: DateTime.parse(map['created_at']),

      // --- MAPPING KOLOM BOT (PENTING) ---
      // Default true jika null (agar aman untuk room lama)
      isBotActive: map['is_bot_active'] ?? true,
      botStep: map['bot_step'] as String?,

      // Parsing Join Profile (jika ada)
      patientName: map['patient'] != null
          ? (map['patient'] as Map<String, dynamic>)['username']
          : null,
    );
  }

  // Helper untuk cek apakah ini giliran bot
  bool get shouldBotReply => isBotActive && status == 'open';
}
