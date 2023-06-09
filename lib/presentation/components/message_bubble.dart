import 'package:chat_app/domain/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  MessageBubble({super.key, required this.message});

  final authData = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: message.sendBy == authData.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: message.sendBy == authData.currentUser!.displayName
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              message.sendBy,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: message.sendBy == authData.currentUser!.displayName
                  ? Colors.blue
                  : Colors.grey,
            ),
            child: Text(
              message.messageText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
