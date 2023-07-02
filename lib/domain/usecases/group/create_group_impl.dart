import 'package:chat_app/data/repository/group_repository_impl.dart';
import 'package:chat_app/domain/usecases/group/create_group.dart';

class CreateGroupUseCaseImpl implements CreateGroupUseCase {
  final GroupChatRepositoryImpl groupChatRepositoryImpl;

  CreateGroupUseCaseImpl(this.groupChatRepositoryImpl);

  @override
  Future execute(List membersList, String groupName) async {
    await groupChatRepositoryImpl.createGroup(membersList, groupName);
  }
}
