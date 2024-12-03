import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/main.dart';
import 'package:uuid/uuid.dart';
class AppPaths {
  static final AppPaths _instance = AppPaths._internal();
  factory AppPaths() => _instance;
  AppPaths._internal();

  String? _appDocumentsDirPath; //Use String? for null safety

  Future<String> getAppDocumentsDirPath() async {
    _appDocumentsDirPath ??= (await getApplicationDocumentsDirectory()).path;
    return _appDocumentsDirPath!; //Safe because we check for null
  }
}
class FileUtils {

  
  static Future<String?> saveImage(File image) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final imagePath = p.join(appDocDir.path, 'images');
      final imagesDir = Directory(imagePath);

      // Ensure the directory exists; create it if necessary
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      // Generate a unique filename to prevent overwriting
      final filename = '${const Uuid().v4()}${p.extension(image.path)}';
      final absolutePath = p.join(imagePath, filename);

      // Copy the image to the app's documents directory
      await image.copy(absolutePath);

      // Return the relative path (relative to the app's documents directory)
      return p.join('images', filename);
    } on Exception catch (e) {
      // Log the error for debugging purposes
      print('Error saving image: $e');
      return null; // Indicate failure
    }
  }

  static Future<String> getFullImagePath(String relativePath) async {
    final appDir = await AppPaths().getAppDocumentsDirPath(); // Use your singleton!
    return p.join(appDir, relativePath);
  }

}