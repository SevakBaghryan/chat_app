import 'package:chat_app/presentation/providers/auth_provider.dart';
import 'package:chat_app/presentation/screens/profile_editing_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  final authData = FirebaseAuth.instance;

  final usersCollection = FirebaseFirestore.instance.collection('Users');

  DocumentSnapshot<Map<String, dynamic>>? currentUser;

  void getUser() async {
    currentUser = await usersCollection.doc(authData.currentUser!.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    authProvider.getUserById(authData.currentUser!.uid);

    final myUser = authProvider.user;

    getUser();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        myUser != null
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(myUser.userImageUrl),
                ),
              )
            : const CircularProgressIndicator(),
        myUser != null
            ? Padding(
                padding: const EdgeInsets.only(top: 25, left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${myUser.name} ${myUser.secondName}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      myUser.email,
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileEditingScreen(),
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
  }
}
