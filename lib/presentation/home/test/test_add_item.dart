// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:test_scav/data/product.dart';
// import 'package:test_scav/main.dart';
// import 'package:test_scav/utils/file_utils.dart';



// class AddProductPage extends StatefulWidget {
//   const AddProductPage({Key? key}) : super(key: key);

//   @override
//   State<AddProductPage> createState() => _AddProductPageState();
// }

// class _AddProductPageState extends State<AddProductPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   File? _imageFile;
//   final picker = ImagePicker();
//   bool _isLoading = false;


//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _imageFile = pickedFile != null ? File(pickedFile.path) : null;
//     });
//   }


//   Future<void> _addProduct() async {
//     if (_imageFile == null || _nameController.text.isEmpty) return;


//     setState(() => _isLoading = true);

//     try {
//         final relativePath = await FileUtils.saveImage(_imageFile!);
//         if(relativePath == null) throw Exception('Image save failed');

//         final productBox = await Hive.openBox<Product>(productBoxName);
//         final newProduct = Product(
//           id: FileUtils.generateId(),
//           name: _nameController.text,
//           relativeImagePath: relativePath,
//         );
//         await productBox.add(newProduct);
//         Navigator.pop(context);

//     } on Exception catch (e){
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error adding product: $e")));
//     } finally {
//         setState(() => _isLoading = false);
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Add Product')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Product Name'),
//                 validator: (value) => value == null || value.isEmpty ? 'Enter a name' : null,
//               ),
//               ElevatedButton(onPressed: _pickImage, child: const Text('Pick Image')),
//               if (_imageFile != null) Image.file(_imageFile!, height: 200, width: 200,),
//               ElevatedButton(onPressed: _addProduct, child: const Text('Add Product')),
//                 if (_isLoading) const CircularProgressIndicator(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }


//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }
// }