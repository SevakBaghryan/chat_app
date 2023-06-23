import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  FirebaseAuth authData = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // SEND MESSAGE

  void onSendMessage(TextEditingController messageTextController,
      String chatRoomId, String collectionName) async {
    if (messageTextController.text.isNotEmpty) {
      Map<String, dynamic> message = {
        'sendby': authData.currentUser!.displayName,
        'message': messageTextController.text,
        "type": "text",
        'time': FieldValue.serverTimestamp(),
      };

      await firestore
          .collection(collectionName)
          .doc(chatRoomId)
          .collection('chats')
          .add(message);

      messageTextController.clear();
    } else {
      return;
    }
  }

  // PICK IMAGE

  File? imageFile;

  Future getImage(String chatRoomId, String collectionName) async {
    ImagePicker picker = ImagePicker();

    await picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage(chatRoomId, collectionName);
      }
    });
  }

  // UPLOAD IMAGE

  Future uploadImage(String chatRoomId, String collectionName) async {
    String fileName = const Uuid().v1();
    int status = 1;

    await firestore
        .collection(collectionName)
        .doc(chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set({
      "sendby": authData.currentUser!.displayName,
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    // ignore: body_might_complete_normally_catch_error
    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
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
          .update({"message": imageUrl});
    }
  }

  // PICK FILE

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future pickFile(String chatRoomId, String collectionName) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    pickedFile = result.files.first;

    uploadFile(chatRoomId, collectionName);
  }

  // UPLOAD FILE

  Future uploadFile(String chatRoomId, String collectionName) async {
    String fileName = const Uuid().v1();
    int status = 1;

    await firestore
        .collection(collectionName)
        .doc(chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set({
      "sendby": authData.currentUser!.displayName,
      "message": "",
      "type": "file",
      "time": FieldValue.serverTimestamp(),
    });

    final path = 'files/$fileName';
    final file = File(pickedFile!.path!);

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
          .update({"message": fileUrl});
    }
  }
}
