import 'package:chat_app/models/user.dart';
import 'package:chat_app/presentation/screens/chat_room_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserChatTile extends StatefulWidget {
  final String userId;
  const UserChatTile({super.key, required this.userId});

  @override
  State<UserChatTile> createState() => _UserChatTileState();
}

class _UserChatTileState extends State<UserChatTile> {
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  final chatRoom = FirebaseFirestore.instance.collection('chatroom');

  final authData = FirebaseAuth.instance;

  String chatRoomId(String? user1, String user2) {
    if (user1!.toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }

  AppUser? user;

  Future<void> getUserById(String id) async {
    final documentSnapshot = await usersCollection.doc(id).get();

    final myJson = documentSnapshot.data();

    setState(() {
      user = AppUser.fromJson(myJson!);
    });
  }

  @override
  void initState() {
    getUserById(widget.userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return user != null
        ? ListTile(
            onTap: () {
              String roomId =
                  chatRoomId(authData.currentUser!.email, user!.email);
              final userMap = user!.toJson();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatRoom(
                    chatRoomId: roomId,
                    userMap: userMap,
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user!.userImageUrl),
            ),
            title: Text(
              user!.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            subtitle: Text(user!.email))
        : const CircularProgressIndicator();
  }
}
