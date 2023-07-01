import 'package:flutter/cupertino.dart';

abstract class SignInUseCase {
  Future<void> execute(BuildContext context, String email, String password);
}
