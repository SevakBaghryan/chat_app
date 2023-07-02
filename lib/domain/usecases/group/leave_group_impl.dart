import 'package:chat_app/data/repository/group_repository_impl.dart';
import 'package:chat_app/domain/usecases/group/leave_group.dart';

class LeaveGroupUsecaseImpl extends LeaveGroupUsecase {
  @override
  Future execute(List membersList, String id) async {
    final GroupChatRepositoryImpl groupChatRepositoryImpl =
        GroupChatRepositoryImpl();

    await groupChatRepositoryImpl.leaveGroup(membersList, id);
  }
}
