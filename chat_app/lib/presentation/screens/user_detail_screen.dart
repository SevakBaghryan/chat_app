import 'package:chat_app/models/user.dart';
import 'package:chat_app/presentation/screens/chat_room_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDetailScreen extends StatefulWidget {
  final String userId;
  const UserDetailScreen({
    required this.userId,
    super.key,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  final authData = FirebaseAuth.instance;
  AppUser? user;

  Future<void> getUserById(String id) async {
    final documentSnapshot = await usersCollection.doc(id).get();

    final myJson = documentSnapshot.data();

    setState(() {
      user = AppUser.fromJson(myJson!);
    });
  }

  void sendFriendRequest() async {
    setState(() {
      final userRef = usersCollection.doc(widget.userId);

      userRef.update({
        'friendRequests':
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      });
    });
    getUserById(widget.userId);
  }

  String chatRoomId(String? user1, String user2) {
    if (user1!.toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }

  void onUnfriend() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text("Unfriend"),
        content: const Text("Do you want to remove this friend?"),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              unfriend();
              Navigator.of(context).pop();
            },
            isDefaultAction: true,
            child: const Text('Yes'),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("No"),
          )
        ],
      ),
    );
  }

  void unfriend() {
    DocumentReference currentUserRef =
        usersCollection.doc(authData.currentUser!.uid);

    DocumentReference removingUserRef = usersCollection.doc(widget.userId);
    setState(() {
      currentUserRef.update({
        'friends': FieldValue.arrayRemove([widget.userId])
      });

      removingUserRef.update({
        'friends': FieldValue.arrayRemove([authData.currentUser!.uid])
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text(user != null ? user!.name : ''),
          backgroundColor: Colors.black,
        ),
        body: FutureBuilder(
          future: getUserById(widget.userId),
          builder: (context, snapshot) {
            return user != null
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.green,
                          backgroundImage: NetworkImage(user!.userImageUrl),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25, left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${user!.name} ${user!.secondName}',
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              user!.email,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 16),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            user!.friendRequests
                                    .contains(authData.currentUser!.uid)
                                ? InkWell(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 20),
                                          child: Text(
                                            'Request sent',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : user!.friends
                                        .contains(authData.currentUser!.uid)
                                    ? Row(
                                        children: [
                                          InkWell(
                                            onTap: onUnfriend,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 20),
                                                  child: Text(
                                                    'You are friends',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              String roomId = chatRoomId(
                                                  authData.currentUser!.email,
                                                  user!.email);

                                              final userMap = user!.toJson();

                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatRoom(
                                                    chatRoomId: roomId,
                                                    userMap: userMap,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.chat,
                                              color: Colors.blue,
                                            ),
                                          )
                                        ],
                                      )
                                    : InkWell(
                                        onTap: sendFriendRequest,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: const Center(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 20,
                                              ),
                                              child: Text(
                                                'Add Friend +',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const CircularProgressIndicator();
          },
        ));
  }
}
