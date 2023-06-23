import 'package:chat_app/presentation/components/file_message.dart';
import 'package:chat_app/presentation/components/image_message.dart';
import 'package:chat_app/presentation/components/message_bubble.dart';
import 'package:chat_app/presentation/screens/group_chats/group_info.dart';
import 'package:chat_app/services/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupChatRoom extends StatelessWidget {
  final String groupChatId, groupName;
  GroupChatRoom({
    super.key,
    required this.groupChatId,
    required this.groupName,
  });

  final TextEditingController _message = TextEditingController();
  final FirebaseAuth authData = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final chatServise = ChatService();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        backgroundColor: const Color.fromARGB(255, 59, 113, 151),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GroupInfo(
                        groupName: groupName,
                        groupId: groupChatId,
                      ),
                    ),
                  ),
              icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 1.25,
              child: StreamBuilder(
                stream: _firestore
                    .collection('groups')
                    .doc(groupChatId)
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
                                  : map['type'] == 'notify'
                                      ? Container(
                                          width: size.width,
                                          alignment: Alignment.center,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 8),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.black38,
                                            ),
                                            child: Text(
                                              map['message'],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
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
                        onSubmitted: (value) => chatServise.onSendMessage(
                            _message, groupChatId, 'groups'),
                        controller: _message,
                        decoration: InputDecoration(
                          icon: IconButton(
                            onPressed: () {
                              chatServise.pickFile(groupChatId, 'groups');
                            },
                            icon: const Icon(Icons.file_copy),
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                chatServise.getImage(groupChatId, 'groups');
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
                          chatServise.onSendMessage(
                              _message, groupChatId, 'groups');
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Color.fromARGB(255, 59, 113, 151),
                        ))
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
