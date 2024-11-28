import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'product.g.dart';

@HiveType(typeId: 1) // Use a different type ID than ItemData
class Product extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String relativeImagePath; // Store only the relative path

  Product({
    required this.id,
    required this.name,
    required this.relativeImagePath,
  });
}