import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Searchprovider extends StateNotifier<List<dynamic>> {
  Searchprovider() : super([]);
  final usersCollection = FirebaseFirestore.instance.collection('Users');

  Future<void> searchUser(String searchTerm) async {
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

final searchProvider = StateNotifierProvider<Searchprovider, List<dynamic>>(
    (ref) => Searchprovider());
