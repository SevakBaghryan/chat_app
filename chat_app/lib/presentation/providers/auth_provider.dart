import 'package:chat_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier {
  final authData = FirebaseAuth.instance;

  AppUser? user;

  Future<void> getUserById(String id) async {
    final documentSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(id).get();

    final myJson = documentSnapshot.data();
    user = AppUser.fromJson(myJson!);
    notifyListeners();
  }
}
