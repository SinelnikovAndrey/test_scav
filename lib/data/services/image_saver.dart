import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageSaver {
  static String? _appDocumentsPath;

  static Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _appDocumentsPath = directory.path;
  }

  static Future<String?> saveImage(File image, String relativePath) async {
    if (_appDocumentsPath == null) {
      throw Exception('ImageSaver not initialized. Call ImageSaver.init() first.');
    }
    final absolutePath = path.join(_appDocumentsPath!, relativePath);
    try {
      await image.copy(absolutePath);
      return relativePath;
    } catch (e) {
      print('Error saving image: $e');
      return null;
    }
  }

  static Future<File?> getImage(String relativePath) async {
    if (_appDocumentsPath == null) {
      throw Exception('ImageSaver not initialized. Call ImageSaver.init() first.');
    }
    final absolutePath = path.join(_appDocumentsPath!, relativePath);
    final file = File(absolutePath);
    if (await file.exists()) {
      return file;
    }
    return null;
  }

    static Future<void> deleteImage(String relativePath) async{
      if (_appDocumentsPath == null){
        throw Exception('ImageSaver not initialized. Call ImageSaver.init() first');
      }
      final absolutePath = path.join(_appDocumentsPath!, relativePath);
      final file = File(absolutePath);
      try{
        await file.delete();
      } catch (e){
        print("Error deleting image: $e");
        rethrow; //Rethrow the exception to handle it at a higher level
      }

    }


}