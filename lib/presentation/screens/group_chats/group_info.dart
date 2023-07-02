// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:chat_app/domain/usecases/group/leave_group_impl.dart';
import 'package:chat_app/presentation/screens/home_screen.dart';
import 'package:chat_app/presentation/utils/group_chat_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class GroupInfoScreen extends StatelessWidget {
  final String groupName, groupId;
  GroupInfoScreen({super.key, required this.groupName, required this.groupId});

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final leaveGroup = LeaveGroupUsecaseImpl();
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: StreamBuilder(
        stream: firestore.collection('groups').doc(groupId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List membersList = snapshot.data!['members'];
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: BackButton(),
                  ),
                  SizedBox(
                    height: size.height / 8,
                    width: size.width / 1.1,
                    child: Row(
                      children: [
                        Container(
                          height: size.height / 11,
                          width: size.height / 11,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: Icon(
                            Icons.group,
                            color: Colors.white,
                            size: size.width / 10,
                          ),
                        ),
                        SizedBox(
                          width: size.width / 20,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              groupName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: size.width / 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //

                  SizedBox(
                    height: size.height / 20,
                  ),

                  SizedBox(
                    width: size.width / 1.1,
                    child: Text(
                      "${membersList.length} Members",
                      style: TextStyle(
                        fontSize: size.width / 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: size.height / 20,
                  ),

                  Flexible(
                    child: ListView.builder(
                      itemCount: membersList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            if (GroupChatUtils().checkAdmin(membersList)) {
                              GroupChatUtils().showDialogBox(
                                  index, membersList, context, groupId);
                            }
                          },
                          leading: Icon(Icons.account_circle),
                          title: Text(
                            membersList[index]['name'],
                            style: TextStyle(
                              fontSize: size.width / 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(membersList[index]['email']),
                          trailing: Text(
                              membersList[index]['isAdmin'] ? "Admin" : ""),
                        );
                      },
                    ),
                  ),

                  !GroupChatUtils().checkAdmin(membersList)
                      ? ListTile(
                          onTap: () {
                            leaveGroup.execute(membersList, groupId);

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => HomeScreen()),
                              (route) => false,
                            );
                          },
                          leading: Icon(
                            Icons.logout,
                            color: Colors.redAccent,
                          ),
                          title: Text(
                            "Leave Group",
                            style: TextStyle(
                              fontSize: size.width / 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.redAccent,
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              ),
            );
          } else {
            return Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
        },
      )),
    );
  }
}
