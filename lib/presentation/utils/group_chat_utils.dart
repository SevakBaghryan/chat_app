import 'package:chat_app/domain/usecases/group/remove_member_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupChatUtils {
  final removeMembers = RemoveMemberUseCaseImpl();
  final auth = FirebaseAuth.instance;
  bool checkAdmin(List membersList) {
    bool isAdmin = false;

    for (var element in membersList) {
      if (element['email'] == auth.currentUser!.email) {
        isAdmin = element['isAdmin'];
      }
    }
    return isAdmin;
  }

  void showDialogBox(int index, membersList, BuildContext context, String id) {
    if (auth.currentUser!.email != membersList[index]['email']) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: ListTile(
                onTap: () async {
                  print(index);
                  print(membersList);
                  print(id);
                  await removeMembers.execute(index, membersList, id);
                  Navigator.of(context).pop();
                  print('ee');
                },
                title: const Text(
                  "Remove This Member",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            );
          });
    }
  }
}
