import 'package:chat_app/data/repository/auth_repository_impl.dart';
import 'package:chat_app/domain/usecases/auth/signin.dart';
import 'package:flutter/material.dart';

class SignInUseCaseImpl extends SignInUseCase {
  SignInUseCaseImpl(this.authRepositoryImpl);
  final AuthRepositoryImpl authRepositoryImpl;

  @override
  Future<void> execute(
      BuildContext context, String email, String password) async {
    await authRepositoryImpl.signIn(context, email, password);
  }
}
