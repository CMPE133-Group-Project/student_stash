import 'package:flutter/material.dart';
import 'package:student_stash/current_session.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String owner;
  const ChatBubble({
    super.key, 
    required this.owner,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    var color = (owner == CurrentSession.currentName)
        ? Colors.blue
        : Colors.black;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 16, 
          color: Colors.white
        ),
      ),
    );
  }
}