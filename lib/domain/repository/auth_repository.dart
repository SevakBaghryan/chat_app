import 'dart:io';

import 'package:flutter/cupertino.dart';

abstract class AuthRepository {
  Future<void> signIn(BuildContext context, String email, String password);

  Future<void> signUp(BuildContext context, String email, String name,
      String secondName, String password, String confirmPassword, File? image);

  Future<void> signOut();
}
