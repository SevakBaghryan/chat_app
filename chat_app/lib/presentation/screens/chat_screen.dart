import 'package:chat_app/presentation/components/user_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final authData = FirebaseAuth.instance;
  final usersCOllection = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'My Friends',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        StreamBuilder(
          stream: usersCOllection.doc(authData.currentUser!.uid).snapshots(),
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: !snapshot.hasData
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!['friends'].length,
                      itemBuilder: (context, index) {
                        return UserTile(
                            userId: snapshot.data!['friends'][index]);
                      },
                    ),
            );
          },
        )
      ],
    );
  }
}
