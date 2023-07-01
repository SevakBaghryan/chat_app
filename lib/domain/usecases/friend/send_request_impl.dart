import 'package:chat_app/data/repository/friend_repository_impl.dart';
import 'package:chat_app/domain/usecases/friend/send_request.dart';

class SendrequestUseCaseImpl extends SendRequestUseCase {
  SendrequestUseCaseImpl(this.friendRepositoryImpl);
  final FriendRepositoryImpl friendRepositoryImpl;

  @override
  void execute(String userId) {
    friendRepositoryImpl.sendRequest(userId);
  }
}
