import 'package:chat_app/models/user.dart';
import 'package:chat_app/presentation/components/request_tile.dart';
import 'package:chat_app/presentation/components/user_tile.dart';
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

  List? requestList;

  Future<void> getFriendRequests() async {
    final myUser = await usersCOllection.doc(authData.currentUser!.uid).get();
    setState(() {
      requestList = myUser['friendRequests'];
    });
    print(requestList);
  }

  @override
  void initState() {
    getFriendRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Friend requests'),
        ),
        body: requestList != null
            ? ListView.builder(
                itemCount: requestList!.length,
                itemBuilder: (context, index) => RequestTile(
                  userId: requestList![index],
                ),
              )
            : CircularProgressIndicator());
  }
}
