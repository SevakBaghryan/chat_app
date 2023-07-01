import 'package:file_picker/file_picker.dart';

abstract class PickFile {
  Future<PlatformFile?> pickFile();
}
