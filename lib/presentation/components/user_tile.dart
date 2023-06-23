import 'package:chat_app/models/user.dart';
import 'package:chat_app/presentation/screens/user_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserTile extends StatefulWidget {
  final String userId;
  const UserTile({
    required this.userId,
    super.key,
  });

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  final usersCollection = FirebaseFirestore.instance.collection('Users');
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      UserDetailScreen(userId: widget.userId)));
            },
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user!.userImageUrl),
            ),
            title: Text(user!.name),
            subtitle: Text(user!.email),
          )
        : const CircularProgressIndicator();
  }
}
