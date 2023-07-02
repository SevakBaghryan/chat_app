import 'package:chat_app/domain/models/user.dart';
import 'package:chat_app/infrastructure/providers/get_user.dart';
import 'package:chat_app/presentation/screens/user_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserTile extends ConsumerStatefulWidget {
  final String userId;
  const UserTile({
    required this.userId,
    super.key,
  });

  @override
  ConsumerState<UserTile> createState() => _UserTileState();
}

class _UserTileState extends ConsumerState<UserTile> {
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  AppUser? user;

  final getUserProvider = StateNotifierProvider<GetUserIdProvider, AppUser?>(
      (ref) => GetUserIdProvider());
  @override
  Widget build(BuildContext context) {
    user = ref.watch(getUserProvider);
    return FutureBuilder(
      future: ref.read(getUserProvider.notifier).getUserById(widget.userId),
      builder: (context, snapshot) {
        return user != null
            ? ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          UserDetailScreen(userId: widget.userId)));
                },
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user!.userImageUrl),
                ),
                title: Text(user!.name),
                subtitle: Text(user!.email),
              )
            : const CircularProgressIndicator();
      },
    );
  }
}
