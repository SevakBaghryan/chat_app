import 'package:flutter/material.dart';

abstract class ChatRepository {
  Future<void> sendMessage(
    TextEditingController messageTextController,
    String chatRoomId,
    String collectionName,
  );

  Future<void> sendImage(String chatRoomId, String collectionName);

  Future<void> sendFile(String chatRoomId, String collectionName);
}
