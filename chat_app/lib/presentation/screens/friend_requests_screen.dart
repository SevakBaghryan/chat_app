import 'package:chat_app/presentation/components/request_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  final authData = FirebaseAuth.instance;
  final usersCOllection = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Friend requests'),
        ),
        body: StreamBuilder(
          stream: usersCOllection.doc(authData.currentUser!.uid).snapshots(),
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: !snapshot.hasData
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!['friendRequests'].length,
                      itemBuilder: (context, index) {
                        return RequestTile(
                            userId: snapshot.data!['friendRequests'][index]);
                      },
                    ),
            );
          },
        ));
  }
}
