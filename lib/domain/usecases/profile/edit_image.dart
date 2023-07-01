import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

abstract class EditImageUseCase {
  Future<void> execute(
      ImageSource imageSource, WidgetRef ref, BuildContext context);
}
