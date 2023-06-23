import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ImageMessage extends StatelessWidget {
  final Size size;
  final Map<String, dynamic> map;
  ImageMessage({
    super.key,
    required this.map,
    required this.size,
  });

  final authData = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height / 2.2,
      width: size.width,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      alignment: map['sendby'] == authData.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: map['sendby'] == authData.currentUser!.displayName
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Text(
              map['sendby'],
              style: TextStyle(color: Colors.grey),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ShowImage(
                  imageUrl: map['message'],
                ),
              ),
            ),
            child: Container(
              height: size.height / 2.5,
              width: size.width / 2,
              decoration: BoxDecoration(border: Border.all()),
              alignment: map['message'] != "" ? null : Alignment.center,
              child: map['message'] != ""
                  ? Image.network(
                      map['message'],
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
