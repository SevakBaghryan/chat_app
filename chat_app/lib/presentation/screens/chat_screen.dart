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

  List? friendsList;

  Future<void> getFriends() async {
    final myUser = await usersCOllection.doc(authData.currentUser!.uid).get();
    setState(() {
      friendsList = myUser['friends'];
    });
  }

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
        FutureBuilder(
          future: getFriends(),
          builder: (context, snapshot) {
            return friendsList != null
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: friendsList!.length,
                    itemBuilder: (context, index) => UserTile(
                      userId: friendsList![index],
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        )
      ],
    );
  }
}
