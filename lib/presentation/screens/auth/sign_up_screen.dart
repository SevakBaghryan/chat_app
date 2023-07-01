import 'package:chat_app/data/repository/auth_repository_impl.dart';
import 'package:chat_app/domain/usecases/auth/signup_impl.dart';
import 'package:chat_app/infrastructure/providers/image_provider.dart';
import 'package:chat_app/presentation/components/button.dart';
import 'package:chat_app/presentation/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  final Function()? toggleScreens;
  const SignUpScreen({
    super.key,
    required this.toggleScreens,
  });

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final emailTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final secondNameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  final AuthRepositoryImpl authRepositoryImpl = AuthRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    final SignupUseCaseImpl signUp = SignupUseCaseImpl(authRepositoryImpl);
    final image = ref.watch(imageProvider);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign In and Start Chat With Your Friends',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () async {
                    ref
                        .read(imageProvider.notifier)
                        .getImage(ImageSource.gallery);
                  },
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
                              image,
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
                  onTap: () => signUp.execute(
                    context,
                    emailTextController.text,
                    nameTextController.text,
                    secondNameTextController.text,
                    passwordTextController.text,
                    confirmPasswordTextController.text,
                    image,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    GestureDetector(
                      onTap: widget.toggleScreens,
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
