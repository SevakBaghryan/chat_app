import 'package:chat_app/data/repository/profile_repository_impl.dart';
import 'package:chat_app/domain/usecases/profile/edit_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditImageUsecaseImpl extends EditImageUseCase {
  EditImageUsecaseImpl(this.profileRepositoryImpl);
  final ProfileRepositoryImpl profileRepositoryImpl;

  @override
  Future<void> execute(
      ImageSource imageSource, WidgetRef ref, BuildContext context) async {
    await profileRepositoryImpl.editProfileImage(imageSource, ref, context);
  }
}
