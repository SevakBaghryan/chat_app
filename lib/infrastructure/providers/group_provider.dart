import 'package:chat_app/domain/models/group_member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupProvider extends StateNotifier<List<Map<String, dynamic>>> {
  GroupProvider() : super([]) {
    getCurrentUserDetails();
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  String? userId;

  Future getCurrentUserDetails() async {
    await _firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((map) {
      GroupMember groupMember = GroupMember(
          uid: _auth.currentUser!.uid,
          userImageUrl: map['userImageUrl'],
          email: map['email'],
          name: map['name'],
          isAdmin: true);

      state.add(groupMember.toJson());
    });
  }

  void onResultTap(int index, List foundUsers) async {
    bool isAlreadyExist = false;

    for (int i = 0; i < state.length; i++) {
      if (state[i]['email'] == foundUsers[index]['email']) {
        isAlreadyExist = true;
      }
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .where('email', isEqualTo: foundUsers[index]['email'])
        .get();

    for (var document in querySnapshot.docs) {
      userId = document.id;
    }

    if (!isAlreadyExist) {
      GroupMember newMember = GroupMember(
          uid: userId as String,
          userImageUrl: foundUsers[index]['userImageUrl'],
          email: foundUsers[index]['email'],
          name: foundUsers[index]['name'],
          isAdmin: false);
      print(444444);
      state.add(newMember.toJson());
    }
  }

  void onRemoveMembers(int index) {
    if (state[index]['email'] != _auth.currentUser!.email) {
      state.removeAt(index);
    }
  }

  void remove() {
    state.clear();
    getCurrentUserDetails();
  }
}
