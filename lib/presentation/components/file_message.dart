import 'package:chat_app/domain/models/message.dart';
import 'package:chat_app/presentation/components/downloading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FileMessage extends StatelessWidget {
  final Size size;
  final Message message;
  FileMessage({
    super.key,
    required this.size,
    required this.message,
  });

  final authData = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Reference ref = FirebaseStorage.instance.refFromURL(message.messageText);

    return Container(
      width: size.width,
      alignment: message.sendBy == authData.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: message.sendBy == authData.currentUser!.displayName
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              message.sendBy,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Container(
            width: 200,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: message.sendBy == authData.currentUser!.displayName
                  ? Colors.blue
                  : Colors.grey,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    ref.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => DownloadingDialog(
                        fileUrl: message.messageText,
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white,
                        width: 3, //                   <--- border width here
                      ),
                    ),
                    child: const Icon(
                      Icons.download,
                      color: Colors.white,
                      size: 39,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
