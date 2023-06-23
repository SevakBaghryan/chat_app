import 'package:chat_app/presentation/components/user_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final authData = FirebaseAuth.instance;
  final usersCOllection = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('My Friends'),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
      ),
    );
  }
}
