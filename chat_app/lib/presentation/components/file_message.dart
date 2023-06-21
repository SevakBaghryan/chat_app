import 'package:chat_app/presentation/components/downloading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FileMessage extends StatelessWidget {
  final Size size;
  final Map<String, dynamic> map;
  FileMessage({
    super.key,
    required this.size,
    required this.map,
  });

  final authData = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      alignment: map['sendby'] == authData.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: map['sendby'] == authData.currentUser!.displayName
              ? Colors.blue
              : Colors.grey,
        ),
        child: Row(
          children: [
            const Text(
              'File',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => DownloadingDialog(
                    ref: FirebaseStorage.instance.refFromURL(
                      map['message'],
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.download,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
