// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:chat_app/domain/models/user.dart';
import 'package:chat_app/presentation/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditingScreen extends StatefulWidget {
  final AppUser myUser;
  const ProfileEditingScreen({required this.myUser, super.key});

  @override
  State<ProfileEditingScreen> createState() => _ProfileEditingScreenState();
}

class _ProfileEditingScreenState extends State<ProfileEditingScreen> {
  final authData = FirebaseAuth.instance;

  final usersCollection = FirebaseFirestore.instance.collection('Users');

  final _nameTextController = TextEditingController();
  final _secondNameTextController = TextEditingController();

  void editProfileData(String newName) {
    DocumentReference userRef = usersCollection.doc(authData.currentUser!.uid);
    SnackBar snackBar(String text) => SnackBar(
          content: Text(text),
        );

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar('Write some text!'));
    } else if (newName == _nameTextController.text) {
      userRef.update({
        'name': newName,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar('Your Name is changed'));
    } else if (newName == _secondNameTextController.text) {
      userRef.update({
        'secondName': newName,
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar('Your SecondName is changed'));
    }
  }

  void editProfileImage(ImageSource imageSource) async {
    await pickImage(imageSource);
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference storageReference = FirebaseStorage.instance.ref();
    Reference bucketRef = storageReference.child('images');
    Reference imageRef = bucketRef.child(uniqueName);
    DocumentReference userRef = usersCollection.doc(authData.currentUser!.uid);

    final snapshot = await imageRef.putFile(image!).whenComplete(() => null);

    final imageUrl = await snapshot.ref.getDownloadURL();

    userRef.update({
      'userImageUrl': imageUrl,
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false);
  }

  File? image;

  Future pickImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(
      () {
        this.image = imageTemporary;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                                editProfileImage(ImageSource.camera);
                              },
                            ),
                            TextButton(
                              child: const Text('Gallery'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                editProfileImage(ImageSource.gallery);
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
                    editProfileData(_nameTextController.text);
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
                    editProfileData(_secondNameTextController.text);
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
