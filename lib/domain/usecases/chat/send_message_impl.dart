import 'package:chat_app/data/repository/chat_repository_impl.dart';
import 'package:chat_app/domain/usecases/chat/send_message.dart';
import 'package:flutter/src/widgets/editable_text.dart';

class SendMessageUseCaseImpl extends SendMessageUseCase {
  SendMessageUseCaseImpl(this.chatRepositoryImpl);
  final ChatRepositoryImpl chatRepositoryImpl;

  @override
  Future<void> execute(
    TextEditingController messageTextController,
    String chatRoomId,
    String collectionName,
  ) async {
    chatRepositoryImpl.sendMessage(
        messageTextController, chatRoomId, collectionName);
  }
}
