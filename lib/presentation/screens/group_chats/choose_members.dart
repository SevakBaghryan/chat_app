import 'package:chat_app/infrastructure/providers/group_provider.dart';
import 'package:chat_app/infrastructure/providers/search_provider.dart';
import 'package:chat_app/presentation/screens/group_chats/create_group_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseMembersInGroup extends ConsumerStatefulWidget {
  const ChooseMembersInGroup({Key? key}) : super(key: key);

  @override
  ConsumerState<ChooseMembersInGroup> createState() =>
      _ChooseMembersInGroupState();
}

class _ChooseMembersInGroupState extends ConsumerState<ChooseMembersInGroup> {
  final groupProvider =
      StateNotifierProvider<GroupProvider, List<Map<String, dynamic>>>(
          (ref) => GroupProvider());

  final searchProvider = StateNotifierProvider<Searchprovider, List<dynamic>>(
      (ref) => Searchprovider());
  @override
  Widget build(BuildContext context) {
    final TextEditingController _search = TextEditingController();
    final foundUsers = ref.watch(searchProvider);
    final membersList = ref.watch(groupProvider);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Members"),
        backgroundColor: const Color.fromARGB(255, 59, 113, 151),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: membersList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () =>
                        ref.read(groupProvider.notifier).onRemoveMembers(index),
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                      membersList[index]['userImageUrl'],
                    )),
                    title: Text(membersList[index]['name']),
                    subtitle: Text(membersList[index]['email']),
                    trailing: const Icon(Icons.close),
                  );
                },
              ),
            ),
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: SizedBox(
                height: size.height / 14,
                width: size.width / 1.15,
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search",
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
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                Color.fromARGB(255, 74, 141, 180),
              )),
              onPressed: () {
                print(11);
                ref.read(searchProvider.notifier).searchUser(_search.text);
                // print(foundUsers.first);
              },
              child: const Text("Search"),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: foundUsers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    print(11);
                    ref
                        .read(groupProvider.notifier)
                        .onResultTap(index, foundUsers);
                  },
                  leading: Image.network(foundUsers[index]['userImageUrl']),
                  title: Text(foundUsers[index]['name']),
                  subtitle: Text(foundUsers[index]['email']),
                  trailing: const Icon(Icons.add),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: membersList.length >= 2
          ? FloatingActionButton(
              child: const Icon(Icons.forward),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CreateGroup(
                    membersList: membersList,
                  ),
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
