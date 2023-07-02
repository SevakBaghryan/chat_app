import 'package:chat_app/domain/models/group.dart';
import 'package:chat_app/domain/models/message.dart';
import 'package:chat_app/domain/repository/group_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class GroupChatRepositoryImpl extends GroupChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Future createGroup(List membersList, String groupName) async {
    String groupId = const Uuid().v1();

    Group newGroup = Group(members: membersList, groupId: groupId);

    await _firestore.collection('groups').doc(groupId).set(newGroup.toJson());

    for (int i = 0; i < membersList.length; i++) {
      String uid = membersList[i]['uid'];

      await _firestore
          .collection('Users')
          .doc(uid)
          .collection('groups')
          .doc(groupId)
          .set({
        "name": groupName,
        "id": groupId,
      });
    }

    Message message = Message(
      messageText: "${_auth.currentUser!.displayName} Created This Group.",
      sendBy: '',
      type: 'notify',
      time: DateTime.now().toIso8601String(),
    );

    await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .add(message.toJson());
  }

  @override
  Future leaveGroup(List membersList, String id) async {
    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == _auth.currentUser!.uid) {
        membersList.removeAt(i);
      }
    }

    await _firestore.collection('groups').doc(id).update({
      "members": membersList,
    });

    await _firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .collection('groups')
        .doc(id)
        .delete();
  }

  @override
  Future removeMembers(int index, List membersList, String id) async {
    String uid = membersList[index]['uid'];

    membersList.removeAt(index);

    await _firestore.collection('groups').doc(id).update({
      "members": membersList,
    }).then((value) async {
      await _firestore
          .collection('Users')
          .doc(uid)
          .collection('groups')
          .doc(id)
          .delete();
    });
  }
}
