// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/data/repository/profile_repository_impl.dart';
import 'package:chat_app/domain/models/user.dart';
import 'package:chat_app/domain/usecases/profile/edit_image_impl.dart';
import 'package:chat_app/domain/usecases/profile/edit_name_impl.dart';
import 'package:chat_app/domain/usecases/profile/edit_secondname_impl.dart';
import 'package:chat_app/presentation/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditingScreen extends ConsumerStatefulWidget {
  final AppUser myUser;
  const ProfileEditingScreen({required this.myUser, super.key});

  @override
  ConsumerState<ProfileEditingScreen> createState() =>
      _ProfileEditingScreenState();
}

class _ProfileEditingScreenState extends ConsumerState<ProfileEditingScreen> {
  final authData = FirebaseAuth.instance;

  final usersCollection = FirebaseFirestore.instance.collection('Users');

  final _nameTextController = TextEditingController();
  final _secondNameTextController = TextEditingController();

  final ProfileRepositoryImpl profileRepositoryImpl = ProfileRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    final EditNameUsecaseImpl editname =
        EditNameUsecaseImpl(profileRepositoryImpl);
    final EditSecondNameUseCaseImpl editSecondName =
        EditSecondNameUseCaseImpl(profileRepositoryImpl);
    final EditImageUsecaseImpl editImage =
        EditImageUsecaseImpl(profileRepositoryImpl);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: const Text('Edit profile'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false);
                },
                icon: const Icon(Icons.check)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Camera Or Gallery?'),
                          actions: [
                            TextButton(
                              child: const Text('Camera'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                editImage.execute(
                                    ImageSource.camera, ref, context);
                              },
                            ),
                            TextButton(
                              child: const Text('Gallery'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                editImage.execute(
                                    ImageSource.gallery, ref, context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(widget.myUser.userImageUrl),
                      ),
                      const Positioned(
                        bottom: 10,
                        right: 10,
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _nameTextController,
              decoration: InputDecoration(
                hintText: widget.myUser.name,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                labelText: 'Name',
                labelStyle: const TextStyle(color: Colors.black),
                suffixIcon: IconButton(
                  onPressed: () {
                    editname.execute(_nameTextController.text, context);
                  },
                  icon: const Icon(
                    Icons.check,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _secondNameTextController,
              decoration: InputDecoration(
                hintText: widget.myUser.secondName,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                labelText: 'Second Name',
                labelStyle: const TextStyle(
                  color: Colors.black,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    editSecondName.execute(
                        _secondNameTextController.text, context);
                  },
                  icon: const Icon(Icons.check),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
