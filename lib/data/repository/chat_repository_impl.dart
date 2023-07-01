import 'dart:io';

import 'package:chat_app/domain/File/file_picker_impl.dart';
import 'package:chat_app/domain/image/image_picker_impl.dart';
import 'package:chat_app/domain/models/message.dart';
import 'package:chat_app/domain/repository/chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatRepositoryImpl extends ChatRepository {
  final authData = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  @override
  Future<void> sendMessage(
    TextEditingController messageTextController,
    String chatRoomId,
    String collectionName,
  ) async {
    if (messageTextController.text.isNotEmpty) {
      final message = Message(
        messageText: messageTextController.text,
        sendBy: authData.currentUser!.displayName as String,
        type: 'text',
        time: DateTime.now().toIso8601String(),
      );

      await firestore
          .collection(collectionName)
          .doc(chatRoomId)
          .collection('chats')
          .add(message.toJson());

      messageTextController.clear();
    } else {
      return;
    }
  }

  @override
  Future<void> sendImage(String chatRoomId, String collectionName) async {
    final imageFile = await PickImageImpl().pickImage(ImageSource.gallery);
    if (imageFile == null) {
      return;
    }
    String fileName = const Uuid().v1();
    int status = 1;

    final message = Message(
      messageText: '',
      sendBy: authData.currentUser!.displayName as String,
      type: 'img',
      time: DateTime.now().toIso8601String(),
    );

    await firestore
        .collection(collectionName)
        .doc(chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set(message.toJson());

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    // ignore: body_might_complete_normally_catch_error
    var uploadTask = await ref.putFile(imageFile).catchError((error) async {
      await firestore
          .collection(collectionName)
          .doc(chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await firestore
          .collection(collectionName)
          .doc(chatRoomId)
          .collection('chats')
          .doc(fileName)
          .update({"messageText": imageUrl});
    }
  }

  @override
  Future<void> sendFile(String chatRoomId, String collectionName) async {
    final pickedFile = await PickFileImpl().pickFile();
    if (pickedFile == null) {
      return;
    }
    String fileName = const Uuid().v1();
    int status = 1;

    final message = Message(
      messageText: '',
      sendBy: authData.currentUser!.displayName as String,
      type: 'file',
      time: DateTime.now().toIso8601String(),
    );

    await firestore
        .collection(collectionName)
        .doc(chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set(message.toJson());

    final path = 'files/$fileName';
    final file = File(pickedFile.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    // ignore: body_might_complete_normally_catch_error
    var uploadTask = await ref.putFile(file).catchError((error) async {
      await firestore
          .collection(collectionName)
          .doc(chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String fileUrl = await uploadTask.ref.getDownloadURL();

      await firestore
          .collection(collectionName)
          .doc(chatRoomId)
          .collection('chats')
          .doc(fileName)
          .update({"messageText": fileUrl});
    }
  }
}
