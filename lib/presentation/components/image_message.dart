import 'package:chat_app/domain/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ImageMessage extends StatelessWidget {
  final Size size;
  final Message message;
  ImageMessage({
    super.key,
    required this.message,
    required this.size,
  });

  final authData = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height / 2.2,
      width: size.width,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      alignment: message.sendBy == authData.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: message.sendBy == authData.currentUser!.displayName
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Text(
              message.sendBy,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ShowImage(
                  imageUrl: message.messageText,
                ),
              ),
            ),
            child: Container(
              height: size.height / 2.5,
              width: size.width / 2,
              decoration: BoxDecoration(border: Border.all()),
              alignment: message.messageText != "" ? null : Alignment.center,
              child: message.messageText != ""
                  ? Image.network(
                      message.messageText,
                      fit: BoxFit.cover,
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
