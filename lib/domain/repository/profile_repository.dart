import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileRepository {
  void editProfileName(String newName, BuildContext context);
  void editProfileSecondName(String newSecondName, BuildContext context);
  Future<void> editProfileImage(
      ImageSource imageSource, WidgetRef ref, BuildContext context);
}
