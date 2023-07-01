import 'package:chat_app/domain/File/file_picker.dart';
import 'package:file_picker/file_picker.dart';

class PickFileImpl extends PickFile {
  @override
  Future<PlatformFile?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) return result.files.first;

    return null;
  }
}
