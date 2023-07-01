import 'package:flutter/material.dart';

abstract class SendMessageUseCase {
  Future<void> execute(
    TextEditingController messageTextController,
    String chatRoomId,
    String collectionName,
  );
}
