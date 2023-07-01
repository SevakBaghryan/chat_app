import 'dart:io';

import 'package:chat_app/data/repository/auth_repository_impl.dart';
import 'package:chat_app/domain/usecases/auth/signup.dart';
import 'package:flutter/widgets.dart';

class SignupUseCaseImpl extends SignUpUseCase {
  SignupUseCaseImpl(this.authRepositoryImpl);
  final AuthRepositoryImpl authRepositoryImpl;

  @override
  Future<void> execute(
    BuildContext context,
    String email,
    String name,
    String secondName,
    String password,
    String confirmPassword,
    File? image,
  ) async {
    await authRepositoryImpl.signUp(
      context,
      email,
      name,
      secondName,
      password,
      confirmPassword,
      image,
    );
  }
}
