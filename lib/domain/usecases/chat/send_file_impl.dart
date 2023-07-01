import 'package:chat_app/data/repository/chat_repository_impl.dart';
import 'package:chat_app/domain/usecases/chat/send_file.dart';

class SendFileUseCaseImpl extends SendFileUseCase {
  SendFileUseCaseImpl(this.chatRepositoryImpl);
  final ChatRepositoryImpl chatRepositoryImpl;

  @override
  Future<void> execute(String chatRoomId, String collectionName) async {
    chatRepositoryImpl.sendFile(chatRoomId, collectionName);
  }
}
