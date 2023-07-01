import 'package:chat_app/data/repository/friend_repository_impl.dart';
import 'package:chat_app/domain/usecases/friend/accept_request.dart';

class AcceptrequestUseCaseImpl extends AcceptRequestUseCase {
  AcceptrequestUseCaseImpl(this.friendRepositoryImpl);
  final FriendRepositoryImpl friendRepositoryImpl;

  @override
  void execute(String userId) {
    friendRepositoryImpl.acceptRequest(userId);
  }
}
