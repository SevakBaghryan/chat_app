import 'package:chat_app/presentation/components/file_message.dart';
import 'package:chat_app/presentation/components/image_message.dart';
import 'package:chat_app/presentation/components/message_bubble.dart';
import 'package:chat_app/services/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
  final String chatRoomId;
  final Map<String, dynamic> userMap;
  ChatRoom({
    required this.chatRoomId,
    required this.userMap,
    super.key,
  });

  final TextEditingController _message = TextEditingController();
  final FirebaseAuth authData = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final chatServise = ChatService();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(userMap['name']),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 1.25,
              child: StreamBuilder(
                stream: _firestore
                    .collection('chatroom')
                    .doc(chatRoomId)
                    .collection('chats')
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map =
                              snapshot.data!.docs[index].data();

                          return map['type'] == "text"
                              ? MessageBubble(map: map)
                              : map['type'] == "img"
                                  ? ImageMessage(map: map, size: size)
                                  : FileMessage(size: size, map: map);
                        });
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: SizedBox(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height / 18,
                      width: size.width / 1.3,
                      child: TextField(
                        onSubmitted: (value) =>
                            chatServise.onSendMessage(_message, chatRoomId),
                        controller: _message,
                        decoration: InputDecoration(
                          icon: IconButton(
                            onPressed: () {
                              chatServise.pickFile(chatRoomId);
                            },
                            icon: const Icon(Icons.file_copy),
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                chatServise.getImage(chatRoomId);
                              },
                              icon: const Icon(Icons.image)),
                          hintText: 'Send message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          chatServise.onSendMessage(_message, chatRoomId);
                        },
                        icon: const Icon(Icons.send))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
