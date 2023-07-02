import 'package:chat_app/domain/models/user.dart';
import 'package:chat_app/infrastructure/providers/get_user.dart';
import 'package:chat_app/presentation/screens/chat_room_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserChatTile extends ConsumerStatefulWidget {
  final String userId;
  const UserChatTile({super.key, required this.userId});

  @override
  ConsumerState<UserChatTile> createState() => _UserChatTileState();
}

class _UserChatTileState extends ConsumerState<UserChatTile> {
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

  final getUserProvider = StateNotifierProvider<GetUserIdProvider, AppUser?>(
      (ref) => GetUserIdProvider());
  @override
  Widget build(BuildContext context) {
    user = ref.watch(getUserProvider);
    return FutureBuilder(
      future: ref.read(getUserProvider.notifier).getUserById(widget.userId),
      builder: (context, snapshot) => user != null
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
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              subtitle: Text(user!.email))
          : const CircularProgressIndicator(),
    );
  }
}
