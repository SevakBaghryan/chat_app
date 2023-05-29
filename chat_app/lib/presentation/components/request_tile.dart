import 'package:chat_app/models/user.dart';
import 'package:chat_app/presentation/screens/user_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestTile extends StatefulWidget {
  final userId;

  const RequestTile({
    required this.userId,
    super.key,
  });

  @override
  State<RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  final authData = FirebaseAuth.instance;
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  AppUser? user;

  Future<void> getUserById(String id) async {
    final documentSnapshot = await usersCollection.doc(id).get();

    final myJson = documentSnapshot.data();

    setState(() {
      user = AppUser.fromJson(myJson!);
    });
  }

  void acceptrequest() async {
    setState(() {
      DocumentReference currentUserRef =
          usersCollection.doc(authData.currentUser!.uid);

      DocumentReference requestedUserRef = usersCollection.doc(widget.userId);

      currentUserRef.update({
        'friends': FieldValue.arrayUnion([widget.userId])
      });
      requestedUserRef.update({
        'friends': FieldValue.arrayUnion([authData.currentUser!.uid])
      });

      currentUserRef.update({
        'friendRequests': FieldValue.arrayRemove([widget.userId])
      });
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
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user!.userImageUrl),
            ),
            title: Text(user!.name),
            subtitle: Text(user!.email),
            trailing: Container(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      print('NO');
                    },
                    icon: Icon(
                      Icons.cancel,
                      size: 35,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: acceptrequest,
                    icon: Icon(
                      Icons.check_circle,
                      size: 35,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          )
        : const CircularProgressIndicator();
  }
}
