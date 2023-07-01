import 'package:chat_app/data/repository/chat_repository_impl.dart';
import 'package:chat_app/domain/usecases/chat/send_image.dart';

class SendImageUseCaseImpl extends SendImageUseCase {
  SendImageUseCaseImpl(this.chatRepositoryImpl);
  final ChatRepositoryImpl chatRepositoryImpl;

  @override
  Future<void> execute(String chatRoomId, String collectionName) async {
    chatRepositoryImpl.sendImage(chatRoomId, collectionName);
  }
}
