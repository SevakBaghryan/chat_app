import 'package:chat_app/presentation/components/user_chat_tile.dart';
import 'package:chat_app/presentation/screens/group_chats/group_chats_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: firestore
            .collection('Users')
            .doc(auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            final List friendsList = snapshot.data!['friends'];
            return ListView.builder(
              itemCount: friendsList.length,
              itemBuilder: (context, index) {
                return UserChatTile(userId: friendsList[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 74, 141, 180),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const GroupChatsScreen(),
          ));
        },
        child: const Icon(Icons.group),
      ),
    );
  }
}
