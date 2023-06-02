import 'dart:io';

import 'package:chat_app/models/user.dart';
import 'package:chat_app/presentation/components/button.dart';
import 'package:chat_app/presentation/components/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  final Function()? onTap;
  const SignUpScreen({
    super.key,
    required this.onTap,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailTextController = TextEditingController();

  final nameTextController = TextEditingController();

  final secondNameTextController = TextEditingController();

  final passwordTextController = TextEditingController();

  final confirmPasswordTextController = TextEditingController();
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  final authData = FirebaseAuth.instance;
  final authSrevises = FirebaseAuth.instance;

  void signUp() async {
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pick an image')),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      if (passwordTextController.text != confirmPasswordTextController.text) {
        Navigator.pop(context);
        showMessage("Password don't match");
        return;
      }

      try {
        String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();

        Reference storageReference = FirebaseStorage.instance.ref();
        Reference bucketRef = storageReference.child('images');
        Reference imageRef = bucketRef.child(uniqueName);

        final snapshot =
            await imageRef.putFile(image!).whenComplete(() => null);

        final imageUrl = await snapshot.ref.getDownloadURL();

        final newUser = AppUser(
          userImageUrl: imageUrl,
          email: emailTextController.text,
          name: nameTextController.text,
          secondName: secondNameTextController.text,
        );

        final userCredential = await authData.createUserWithEmailAndPassword(
          email: emailTextController.text.trim(),
          password: passwordTextController.text.trim(),
        );

        userCredential.user!.updateDisplayName(nameTextController.text);

        usersCollection.doc(userCredential.user!.uid).set(
              newUser.toJson(),
            );
        if (mounted) {
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        showMessage(e.code);
      }
    }
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  File? image;

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(
      () {
        this.image = imageTemporary;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Sign In and Start Chat With Your Friends',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.purple[100],
                    child: image == null
                        ? const Icon(
                            Icons.add_a_photo_outlined,
                            size: 40,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              image!,
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                  ),
                ),
                MyTextField(
                  controller: emailTextController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                  controller: nameTextController,
                  hintText: 'Your Name',
                  obscureText: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                  controller: secondNameTextController,
                  hintText: 'Your Second Name',
                  obscureText: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                  controller: passwordTextController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                  controller: confirmPasswordTextController,
                  hintText: 'Confirm password',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyButton(
                  text: 'Sign Up',
                  onTap: signUp,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'SignIn now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
