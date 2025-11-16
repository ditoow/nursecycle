class ChatMessage {
  final String text;
  final bool isFromAdmin;
  final String time;

  ChatMessage({
    required this.text,
    required this.isFromAdmin,
    required this.time,
  });
}
