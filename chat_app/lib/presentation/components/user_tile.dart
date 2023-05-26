import 'package:chat_app/presentation/screens/user_detail_screen.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String userImageUrl;
  final String userName;
  final String userEmail;
  final String secondname;
  const UserTile({
    required this.userName,
    required this.userEmail,
    super.key,
    required this.userImageUrl,
    required this.secondname,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserDetailScreen(
              userImageUrl: userImageUrl,
              name: userName,
              email: userEmail,
              secondName: secondname),
        ));
      },
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(userImageUrl),
      ),
      title: Text(userName),
      subtitle: Text(userEmail),
    );
  }
}
