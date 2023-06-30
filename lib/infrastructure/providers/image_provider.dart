import 'dart:io';

import 'package:chat_app/domain/image/image_picker_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageStateNotifier extends StateNotifier<File?> {
  ImageStateNotifier() : super(null);
  final pickImage = PickImageImpl();

  // File? image;

  Future<void> getImage() async {
    state = await pickImage.pickImage();
  }
}

final imageProvider = StateNotifierProvider<ImageStateNotifier, File?>(
    (ref) => ImageStateNotifier());
