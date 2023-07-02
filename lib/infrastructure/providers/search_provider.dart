import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Searchprovider extends StateNotifier<List<dynamic>> {
  Searchprovider() : super([]) {
    state.clear();
  }
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> searchUser(String searchTerm) async {
    final List searchResult = [];
    QuerySnapshot querySnapshot =
        await usersCollection.where('name', isEqualTo: searchTerm).get();

    for (var document in querySnapshot.docs) {
      searchResult.add(document.data());
    }

    for (var documnet in searchResult) {
      if (documnet['email'] == currentUser!.email) {
        searchResult.remove(documnet);
        return;
      }
    }

    state = searchResult;
  }

  Future<void> searchUserId(String searchTerm) async {
    final searchResult = [];
    final querySnapshot =
        await usersCollection.where('name', isEqualTo: searchTerm).get();

    querySnapshot.docs.forEach(
      (document) {
        searchResult.add(document.id);
      },
    );

    state = searchResult;
  }
}
