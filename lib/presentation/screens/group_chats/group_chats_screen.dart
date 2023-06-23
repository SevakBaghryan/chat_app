import 'package:chat_app/presentation/screens/group_chats/choose_members.dart';
import 'package:chat_app/presentation/screens/group_chats/group_chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupChatsScreen extends StatefulWidget {
  const GroupChatsScreen({super.key});

  @override
  State<GroupChatsScreen> createState() => _GroupChatsScreenState();
}

class _GroupChatsScreenState extends State<GroupChatsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;

  List groupList = [];

  @override
  void initState() {
    super.initState();
    getAvailableGroups();
  }

  void getAvailableGroups() async {
    String uid = _auth.currentUser!.uid;

    await _firestore
        .collection('Users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Chats'),
        backgroundColor: const Color.fromARGB(255, 59, 113, 151),
      ),
      body: isLoading
          ? Container(
              width: size.width,
              height: size.height,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GroupChatRoom(
                        groupName: groupList[index]['name'],
                        groupChatId: groupList[index]['id'],
                      ),
                    ),
                  ),
                  leading: const Icon(Icons.group),
                  title: Text(groupList[index]['name']),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ChooseMembersInGroup(),
          ));
        },
        backgroundColor: const Color.fromARGB(255, 74, 141, 180),
        child: const Icon(Icons.create),
      ),
    );
  }
}
