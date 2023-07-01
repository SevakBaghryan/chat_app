import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'image_picker.dart';

class PickImageImpl extends PickImage {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<File?> pickImage(ImageSource imageSource) async {
    final pickedFile = await _imagePicker.pickImage(source: imageSource);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
