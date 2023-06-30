import 'dart:io';

import 'package:chat_app/domain/models/user.dart';
import 'package:chat_app/domain/repository/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthRepositoryImpl extends AuthRepository {
  
  final authData = FirebaseAuth.instance;
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  void showMessage(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Future<void> signIn(
      BuildContext context, String email, String password) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await authData.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (context.mounted) Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showMessage(e.code, context);
    }
  }

  

  @override
  Future<void> signUp(
      BuildContext context,
      String email,
      String name,
      String secondName,
      String password,
      String confirmPassword,
      File? image) async {
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pick an image')),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      if (password != confirmPassword) {
        Navigator.pop(context);
        showMessage("Password don't match", context);
        return;
      }

      try {
        String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();

        Reference storageReference = FirebaseStorage.instance.ref();
        Reference bucketRef = storageReference.child('images');
        Reference imageRef = bucketRef.child(uniqueName);

        final snapshot = await imageRef.putFile(image).whenComplete(() => null);

        final imageUrl = await snapshot.ref.getDownloadURL();

        final newUser = AppUser(
          userImageUrl: imageUrl,
          email: email,
          name: name,
          secondName: secondName,
        );

        final userCredential = await authData.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        userCredential.user!.updateDisplayName(name);

        await usersCollection.doc(userCredential.user!.uid).set(
              newUser.toJson(),
            );

        if (context.mounted) Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        showMessage(e.code, context);
      }
    }
  }

  @override
  Future<void> signOut() async {
    await authData.signOut();
  }
}
