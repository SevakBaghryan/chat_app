import 'package:chat_app/data/repository/group_repository_impl.dart';
import 'package:chat_app/domain/usecases/group/remove_member.dart';

class RemoveMemberUseCaseImpl extends RemoveMemberUseCase {
  final GroupChatRepositoryImpl groupChatRepositoryImpl =
      GroupChatRepositoryImpl();
  @override
  Future execute(int index, List membersList, String id) async {
    await groupChatRepositoryImpl.removeMembers(index, membersList, id);
  }
}
