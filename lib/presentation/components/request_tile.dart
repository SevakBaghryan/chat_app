import 'package:chat_app/data/repository/friend_repository_impl.dart';
import 'package:chat_app/domain/models/user.dart';
import 'package:chat_app/domain/usecases/friend/accept_request_impl.dart';
import 'package:chat_app/domain/usecases/friend/reject_request_impl.dart';
import 'package:chat_app/infrastructure/providers/get_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestTile extends ConsumerStatefulWidget {
  final String userId;

  const RequestTile({
    required this.userId,
    super.key,
  });

  @override
  ConsumerState<RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends ConsumerState<RequestTile> {
  final authData = FirebaseAuth.instance;
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  final FriendRepositoryImpl friendRepositoryImpl = FriendRepositoryImpl();
  AppUser? user;

  final getUserProvider = StateNotifierProvider<GetUserIdProvider, AppUser?>(
      (ref) => GetUserIdProvider());
  @override
  Widget build(BuildContext context) {
    user = ref.watch(getUserProvider);
    final AcceptrequestUseCaseImpl acceptRequest =
        AcceptrequestUseCaseImpl(friendRepositoryImpl);

    final RejectRequestUsecaseImpl rejectRequest =
        RejectRequestUsecaseImpl(friendRepositoryImpl);

    return FutureBuilder(
      future: ref.read(getUserProvider.notifier).getUserById(widget.userId),
      builder: (context, snapshot) {
        return user != null
            ? ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user!.userImageUrl),
                ),
                title: Text(user!.name),
                subtitle: Text(user!.email),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          rejectRequest.execute(widget.userId);
                        },
                        icon: const Icon(
                          Icons.cancel,
                          size: 35,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          acceptRequest.execute(widget.userId);
                        },
                        icon: const Icon(
                          Icons.check_circle,
                          size: 35,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const CircularProgressIndicator();
      },
    );
  }
}
