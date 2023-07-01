import 'package:chat_app/data/repository/friend_repository_impl.dart';
import 'package:chat_app/domain/usecases/friend/reject_request.dart';

class RejectRequestUsecaseImpl extends RejectRequestUseCase {
  RejectRequestUsecaseImpl(this.friendRepositoryImpl);
  final FriendRepositoryImpl friendRepositoryImpl;

  @override
  void execute(String userId) {
    friendRepositoryImpl.rejectRequest(userId);
  }
}
