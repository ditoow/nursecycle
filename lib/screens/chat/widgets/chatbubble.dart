import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isFromAdmin;
  final Color primaryColor;

  const ChatBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isFromAdmin,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isFromAdmin ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar admin
          if (isFromAdmin) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                // opacity 0.2 -> alpha 51
                color: primaryColor.withAlpha(51),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.medical_services,
                color: primaryColor,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Bubble
          Flexible(
            child: Column(
              crossAxisAlignment: isFromAdmin
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isFromAdmin ? Colors.white : primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: isFromAdmin
                          ? const Radius.circular(0)
                          : const Radius.circular(20),
                      bottomRight: isFromAdmin
                          ? const Radius.circular(20)
                          : const Radius.circular(0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        // opacity 0.05 -> alpha 13
                        color: Colors.black.withAlpha(13),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isFromAdmin ? Colors.black87 : Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Avatar user
          if (!isFromAdmin) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                // opacity 0.2 -> alpha 51
                color: Colors.blue.withAlpha(51),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.blue,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
