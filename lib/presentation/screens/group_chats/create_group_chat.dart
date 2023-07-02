import 'package:chat_app/data/repository/group_repository_impl.dart';
import 'package:chat_app/domain/usecases/group/create_group_impl.dart';
import 'package:chat_app/infrastructure/providers/group_provider.dart';
import 'package:chat_app/presentation/screens/chats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateGroup extends ConsumerWidget {
  final List<Map<String, dynamic>> membersList;

  CreateGroup({required this.membersList, Key? key}) : super(key: key);

  final TextEditingController _groupName = TextEditingController();

  final GroupChatRepositoryImpl groupChatRepositoryImpl =
      GroupChatRepositoryImpl();

  final groupProvider =
      StateNotifierProvider<GroupProvider, List<Map<String, dynamic>>>(
          (ref) => GroupProvider());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final createGroup = CreateGroupUseCaseImpl(groupChatRepositoryImpl);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Name"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height / 10,
          ),
          Container(
            height: size.height / 14,
            width: size.width,
            alignment: Alignment.center,
            child: SizedBox(
              height: size.height / 14,
              width: size.width / 1.15,
              child: TextField(
                controller: _groupName,
                decoration: InputDecoration(
                  hintText: "Enter Group Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height / 50,
          ),
          ElevatedButton(
            onPressed: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: ((context) => const Center(
                        child: CircularProgressIndicator(),
                      )));

              await createGroup.execute(membersList, _groupName.text);

              ref.read(groupProvider.notifier).remove();

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChatsScreen(),
              ));
            },
            child: const Text("Create Group"),
          ),
        ],
      ),
    );
  }
}

//