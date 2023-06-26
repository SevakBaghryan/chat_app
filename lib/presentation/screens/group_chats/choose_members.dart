import 'package:chat_app/models/group_member.dart';
import 'package:chat_app/presentation/screens/group_chats/create_group_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChooseMembersInGroup extends StatefulWidget {
  const ChooseMembersInGroup({Key? key}) : super(key: key);

  @override
  State<ChooseMembersInGroup> createState() => _ChooseMembersInGroupState();
}

class _ChooseMembersInGroupState extends State<ChooseMembersInGroup> {
  final TextEditingController _search = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> membersList = [];

  bool isLoading = false;

  Map<String, dynamic>? userMap;

  String? userId;

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }

  void getCurrentUserDetails() async {
    await _firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((map) {
      setState(() {
        GroupMember groupMember = GroupMember(
            uid: _auth.currentUser!.uid,
            userImageUrl: map['userImageUrl'],
            email: map['email'],
            name: map['name'],
            isAdmin: true);

        membersList.add(groupMember.toJson());
      });
    });
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    final querySnapshot = await _firestore
        .collection('Users')
        .where("name", isEqualTo: _search.text)
        .get();

    setState(() {
      userMap = querySnapshot.docs.first.data();
      userId = querySnapshot.docs.first.id;
      isLoading = false;
    });
  }

  void onResultTap() {
    bool isAlreadyExist = false;

    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['email'] == userMap!['email']) {
        isAlreadyExist = true;
      }
    }

    if (!isAlreadyExist) {
      GroupMember newMember = GroupMember(
          uid: userId as String,
          userImageUrl: userMap!['userImageUrl'],
          email: userMap!['email'],
          name: userMap!['name'],
          isAdmin: false);
      setState(() {
        membersList.add(newMember.toJson());

        userMap = null;
      });
    }
  }

  void onRemoveMembers(int index) {
    if (membersList[index]['email'] != _auth.currentUser!.email) {
      setState(() {
        membersList.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    onTap: () => onRemoveMembers(index),
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
            isLoading
                ? Container(
                    height: size.height / 12,
                    width: size.height / 12,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 74, 141, 180),
                    )),
                    onPressed: onSearch,
                    child: const Text("Search"),
                  ),
            userMap != null
                ? ListTile(
                    onTap: onResultTap,
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                      userMap!['userImageUrl'],
                    )),
                    title: Text(userMap!['name']),
                    subtitle: Text(userMap!['email']),
                    trailing: const Icon(Icons.add),
                  )
                : const SizedBox(),
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
