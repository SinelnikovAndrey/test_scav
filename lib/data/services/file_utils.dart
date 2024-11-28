// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:test_scav/data/models/item_data.dart';
// import 'package:path/path.dart' as p;
// import 'package:uuid/uuid.dart';


// // class FileUtils {
// //   static Future<String?> savePickedImageToAppFolder(File? image) async {
// //     if (image == null) return null;
// //     try {
// //       final appDocDir = await getApplicationDocumentsDirectory();
// //       final now = DateTime.now().millisecondsSinceEpoch;
// //       final filename = '$now${p.extension(image.path)}';
// //       final absolutePath = p.join(appDocDir.path, 'images', filename);
// //       final imagesDir = Directory(p.join(appDocDir.path, 'images'));
// //       await imagesDir.create(recursive: true);
// //       await image.copy(absolutePath);
// //       return p.join('images', filename);
// //     } catch (e) {
// //       print('Error saving image: $e');
// //       return null;
// //     }
// //   }

// //   static Future<List<ItemData>> loadItemsFromHive(Box<ItemData> itemBox) async {
// //     try {
// //       return itemBox.values.toList();
// //     } catch (e) {
// //       print('Error loading items from Hive: $e');
// //       return [];
// //     }
// //   }
// // }

// class FileUtils {
//   // Function to save an image to the app's documents directory
//   static Future<String?> savePickedImageToAppFolder(File image) async {
//     try {
//       final appDocDir = await getApplicationDocumentsDirectory();
//       final now = DateTime.now().millisecondsSinceEpoch;
//       final filename = '$now${p.extension(image.path)}';
//       final absolutePath = p.join(appDocDir.path, filename);
//       final imagesDir = Directory(p.join(appDocDir.path, 'Documents'));
//       if (!await imagesDir.exists()) {
//         await imagesDir.create(recursive: true);
//       }
//       await image.copy(absolutePath);
//       return p.join('Documents', filename);
//     } catch (e) {
//       print('Error saving image: $e');
//       return null;
//     }
//   }

//   // Function to get the full path from a relative path (already correct)
//   static Future<String?> getDocumentsPathByRelativePath(String relativePath) async {
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


//   // Function to load all items from the Hive box
//   static Future<List<ItemData>> loadItemsFromHive(Box<ItemData> itemBox) async {
//     try {
//       return itemBox.values.toList(); // Get all items from the box
//     } catch (e) {
//       print("Error loading items from Hive: $e");
//       return []; // Return an empty list in case of error
//     }
//   }

//    static String generateId(){
//        return const Uuid().v4();
//    }
// }