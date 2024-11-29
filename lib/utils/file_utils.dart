import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/main.dart';
import 'package:uuid/uuid.dart';


class FileUtils {
  static Future<String> saveImage(File image) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final imagePath = p.join(appDocDir.path, 'images');
      final now = DateTime.now().millisecondsSinceEpoch;
      final filename = '$now${p.extension(image.path)}';
      final absolutePath = p.join(imagePath, filename);
      final imagesDir = Directory(imagePath);

      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      await image.copy(absolutePath);
      return p.join('images', filename); 
    } catch (e) {
      print('Error saving image: $e'); 
      return ''; 
    }
  }


   static Future<String?> getDocumentsPathByRelativePath(String relativePath) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      if (relativePath.isNotEmpty) {
        return p.join(appDocDir.path, relativePath);
      }
      return null;
    } catch (e) {
      print('Error getting documents path: $e');
      return null;
    }
  }

  static Future<String> getFullImagePath(String relativePath) async {
  try {
    final appDocDir = await getApplicationDocumentsDirectory();
    return p.join(appDocDir.path, relativePath); 
  } catch (e) {
    print('Error getting full image path: $e');
    return ''; 
  }
}


  static Future<List<ItemData>> loadItemsFromHive(Box<ItemData> itemBox) async {
      return itemBox.values.toList();
  }

  static String generateId() {
    return const Uuid().v4();
  }
}



   