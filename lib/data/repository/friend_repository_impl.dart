import 'package:chat_app/domain/repository/friend_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendRepositoryImpl extends FriendRepository {
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  final authData = FirebaseAuth.instance;

  @override
  void sendRequest(String userId) {
    final userRef = usersCollection.doc(userId);

    userRef.update({
      'friendRequests':
          FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
    });
  }

  @override
  void acceptRequest(String userId) {
    DocumentReference currentUserRef =
        usersCollection.doc(authData.currentUser!.uid);

    DocumentReference requestedUserRef = usersCollection.doc(userId);

    currentUserRef.update({
      'friends': FieldValue.arrayUnion([userId])
    });
    requestedUserRef.update({
      'friends': FieldValue.arrayUnion([authData.currentUser!.uid])
    });

    currentUserRef.update({
      'friendRequests': FieldValue.arrayRemove([userId])
    });
  }

  @override
  void rejectRequest(String userId) {
    DocumentReference currentUserRef =
        usersCollection.doc(authData.currentUser!.uid);
    currentUserRef.update({
      'friendRequests': FieldValue.arrayRemove([userId])
    });
  }

  @override
  void unfriend(String userId) {
    DocumentReference currentUserRef =
        usersCollection.doc(authData.currentUser!.uid);

    DocumentReference removingUserRef = usersCollection.doc(userId);

    currentUserRef.update({
      'friends': FieldValue.arrayRemove([userId])
    });

    removingUserRef.update({
      'friends': FieldValue.arrayRemove([authData.currentUser!.uid])
    });
  }
}
