import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';


class AppPaths {
  static final AppPaths _instance = AppPaths._internal();
  factory AppPaths() => _instance;
  AppPaths._internal();

  String? _appDocumentsDirPath; 

  Future<String> getAppDocumentsDirPath() async {
    _appDocumentsDirPath ??= (await getApplicationDocumentsDirectory()).path;
    return _appDocumentsDirPath!; 
  }
}
class FileUtils {

  
  static Future<String?> saveImage(File image) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final imagePath = p.join(appDocDir.path, 'images');
      final imagesDir = Directory(imagePath);

    
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final filename = '${const Uuid().v4()}${p.extension(image.path)}';
      final absolutePath = p.join(imagePath, filename);

      await image.copy(absolutePath);

      return p.join('images', filename);
    } on Exception catch (e) {
      print('Error saving image: $e');
      return null; 
    }
  }

  static Future<String> getFullImagePath(String relativePath) async {
    final appDir = await AppPaths().getAppDocumentsDirPath(); 
    return p.join(appDir, relativePath);
  }

}