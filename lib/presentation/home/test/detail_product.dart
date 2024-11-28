import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/data/product.dart';
import 'package:test_scav/data/services/file_utils.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/file_utils.dart';
import 'package:path/path.dart' as p;


class ProductDetailPage extends StatelessWidget {
  final String productId;
  final String appDocumentsDirPath;
  const ProductDetailPage({super.key, required this.productId, required this.appDocumentsDirPath});

  Future<Product?> _getProduct() async {
    final box = await Hive.openBox<Product>(productBoxName);
    print(
        'productId to retrieve: $productId'); // Print productId BEFORE getting from box
    final product = box.get(productId);
    print(
        'Retrieved product: $product'); // Print the retrieved product (null or the object)
    await box.close();
    return product;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product?>(
      future: _getProduct(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Product Details')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Product Details')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          final product = snapshot.data!;
          return _buildProductDetails(context, product);
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('Product Details')),
            body: const Center(child: Text('Product not found')),
          );
        }
      },
    );
  }

  Widget _buildProductDetails(BuildContext context, Product product) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name, style: AppFonts.h10),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.relativeImagePath.isNotEmpty)
                Image.file(
                  File(p.join(widget.appDocumentsDirPath, 'images',
                      product.relativeImagePath)),
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null)
                      return child; //The image has finished loading
                    return const CircularProgressIndicator(); //Display indicator while loading
                  },
                ),
              const SizedBox(height: 16.0),
              Text('ID: ${product.id}', style: AppFonts.h8),
              const SizedBox(height: 8.0),
              // Text('Description: ${product.description}', style: AppFonts.bodyText),
              const SizedBox(height: 16.0),
              // ... other details (e.g., color, form, group) ...
            ],
          ),
        ),
      ),
    );
  }
}
