import 'package:chat_app/domain/repository/profile_repository.dart';
import 'package:chat_app/infrastructure/providers/image_provider.dart';
import 'package:chat_app/presentation/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_platform_interface/src/types/image_source.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final authData = FirebaseAuth.instance;
  final usersCollection = FirebaseFirestore.instance.collection('Users');

  @override
  Future<void> editProfileImage(
      ImageSource imageSource, WidgetRef ref, BuildContext context) async {
    final image = ref.watch(imageProvider);

    await ref.read(imageProvider.notifier).getImage(imageSource);

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

  @override
  void editProfileName(String newName, BuildContext context) {
    DocumentReference userRef = usersCollection.doc(authData.currentUser!.uid);
    SnackBar snackBar(String text) => SnackBar(
          content: Text(text),
        );

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar('Write some text!'));
    } else {
      userRef.update({
        'name': newName,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar('Your Name is changed'));
    }
  }

  @override
  void editProfileSecondName(String newSecondName, BuildContext context) {
    DocumentReference userRef = usersCollection.doc(authData.currentUser!.uid);
    SnackBar snackBar(String text) => SnackBar(
          content: Text(text),
        );

    if (newSecondName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar('Write some text!'));
    } else {
      userRef.update({
        'secondName': newSecondName,
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar('Your SecondName is changed'));
    }
  }
}
