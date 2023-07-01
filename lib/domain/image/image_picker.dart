import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class PickImage {
  Future<File?> pickImage(ImageSource imageSource);
}
