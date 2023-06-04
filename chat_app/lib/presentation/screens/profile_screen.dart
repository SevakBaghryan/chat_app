import 'package:chat_app/models/user.dart';
import 'package:chat_app/presentation/screens/profile_editing_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserById(authData.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {}
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            user != null
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user!.userImageUrl),
                    ),
                  )
                : const CircularProgressIndicator(),
            user != null
                ? Padding(
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
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfileEditingScreen(
                                myUser: user!,
                              ),
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5)),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 20),
                                child: Text(
                                  'Edit profile',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : const CircularProgressIndicator(),
          ],
        );
      },
    );
  }
}
