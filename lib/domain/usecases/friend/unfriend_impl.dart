import 'package:chat_app/data/repository/friend_repository_impl.dart';
import 'package:chat_app/domain/usecases/friend/unfriend.dart';

class UnfriendUseCaseImpl extends UnfriendUseCase {
  UnfriendUseCaseImpl(this.friendRepositoryImpl);
  final FriendRepositoryImpl friendRepositoryImpl;

  @override
  void execute(String userId) {
    friendRepositoryImpl.unfriend(userId);
  }
}
