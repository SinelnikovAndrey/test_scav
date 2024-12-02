import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/main.dart';
import 'package:uuid/uuid.dart';

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
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final fullPath = p.join(appDocDir.path, relativePath);

      // Check if the file exists
      if (!await File(fullPath).exists()) {
          throw Exception('File not found at $fullPath'); // or a more descriptive error
      }

      return fullPath;
    } catch (e) {
      // If there's an error, re-throw it
      rethrow;
    }
  }
}
// class FileUtils {
//   static Future<String?> saveImage(File image) async {
//   String? absolutePath; // Declare absolutePath outside the try block

//   try {
//     final appDocDir = await getApplicationDocumentsDirectory();
//     final imagePath = p.join(appDocDir.path, 'images');
//     final now = DateTime.now().millisecondsSinceEpoch;
//     final filename = '$now${p.extension(image.path)}';
//     absolutePath = p.join(imagePath, filename); // Assign within the try block

//     final imagesDir = Directory(imagePath);
//     if (!await imagesDir.exists()) {
//       await imagesDir.create(recursive: true);
//     }

//     print('Saving image to: $absolutePath'); // Log the absolute path
//     await image.copy(absolutePath);
//     return p.join('images', filename);
//   } on IOException catch (e) {
//     print('IO Exception saving image: $e, path: $absolutePath');
//     return null;
//   } on FileSystemException catch (e) {
//     print('File system error saving image: $e, path: $absolutePath');
//     return null;
//   } on Exception catch (e) {
//     print('Unexpected error saving image: $e, path: $absolutePath');
//     return null;
//   }
// }


//    static Future<String?> getDocumentsPathByRelativePath(String relativePath) async {
//     try {
//       final appDocDir = await getApplicationDocumentsDirectory();
//       if (relativePath.isNotEmpty) {
//         return p.join(appDocDir.path, relativePath);
//       }
//       return null;
//     } catch (e) {
//       print('Error getting documents path: $e');
//       return null;
//     }
//   }

//   static Future<String> getFullImagePath(String relativePath) async {
//   try {
//     final appDocDir = await getApplicationDocumentsDirectory();
//     return p.join(appDocDir.path, relativePath); 
//   } catch (e) {
//     print('Error getting full image path: $e');
//     return ''; 
//   }
// }


//   static Future<List<ItemData>> loadItemsFromHive(Box<ItemData> itemBox) async {
//       return itemBox.values.toList();
//   }

//   static String generateId() {
//     return const Uuid().v4();
//   }
// }



// class FileUtils {
//   static Future<String> saveImage(File image) async {
//     try {
//       final appDocDir = await getApplicationDocumentsDirectory();
//       final imagePath = p.join(appDocDir.path, 'images');
//       final now = DateTime.now().millisecondsSinceEpoch;
//       final filename = '$now${p.extension(image.path)}';
//       final absolutePath = p.join(imagePath, filename);
//       final imagesDir = Directory(imagePath);

//       if (!await imagesDir.exists()) {
//         await imagesDir.create(recursive: true);
//       }

//       await image.copy(absolutePath);
//       return p.join('images', filename); 
//     } catch (e) {
//       print('Error saving image: $e'); 
//       return ''; 
//     }
//   }


//    static Future<String?> getDocumentsPathByRelativePath(String relativePath) async {
//     try {
//       final appDocDir = await getApplicationDocumentsDirectory();
//       if (relativePath.isNotEmpty) {
//         return p.join(appDocDir.path, relativePath);
//       }
//       return null;
//     } catch (e) {
//       print('Error getting documents path: $e');
//       return null;
//     }
//   }

//   static Future<String> getFullImagePath(String relativePath) async {
//   try {
//     final appDocDir = await getApplicationDocumentsDirectory();
//     return p.join(appDocDir.path, relativePath); 
//   } catch (e) {
//     print('Error getting full image path: $e');
//     return ''; 
//   }
// }


//   static Future<List<ItemData>> loadItemsFromHive(Box<ItemData> itemBox) async {
//       return itemBox.values.toList();
//   }

//   static String generateId() {
//     return const Uuid().v4();
//   }
// }


   