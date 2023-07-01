import 'package:chat_app/domain/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetUserIdProvider extends StateNotifier<AppUser?> {
  GetUserIdProvider() : super(null);

  final usersCollection = FirebaseFirestore.instance.collection('Users');

  Future<AppUser?> getUserById(String id) async {
    final documentSnapshot = await usersCollection.doc(id).get();

    final myJson = documentSnapshot.data();

    state = AppUser.fromJson(myJson!);

    return null;
  }
}

final getUserProvider = StateNotifierProvider<GetUserIdProvider, AppUser?>(
    (ref) => GetUserIdProvider());
