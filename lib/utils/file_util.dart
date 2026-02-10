import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'logger.dart';

class FileUtil {
  static Future<String> getDocumentsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<String?> saveImageToGallery(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        Logger.e('Image file does not exist: $imagePath');
        return null;
      }

      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'photo_mosaic_${DateTime.now().millisecondsSinceEpoch}.png';
      final savedPath = '${directory.path}/$fileName';
      await file.copy(savedPath);
      Logger.d('Image saved: $savedPath');
      return savedPath;
    } catch (e) {
      Logger.e('Failed to save image', e);
      return null;
    }
  }

  static Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        Logger.d('File deleted: $filePath');
        return true;
      }
      return false;
    } catch (e) {
      Logger.e('Failed to delete file', e);
      return false;
    }
  }
}
