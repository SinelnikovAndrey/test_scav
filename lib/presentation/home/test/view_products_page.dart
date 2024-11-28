// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:test_scav/data/product.dart';
// import 'package:test_scav/data/services/file_utils.dart';
// import 'package:test_scav/main.dart';
// import 'package:test_scav/presentation/home/test/detail_product.dart';
// import 'package:test_scav/utils/app_router.dart';
// import 'package:test_scav/utils/file_utils.dart';
// import 'package:test_scav/widgets/default_button.dart';


// class ViewProductsPage extends StatelessWidget {
//   const ViewProductsPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Products')),
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(right: 5.0),
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height * 0.1,
//           width: MediaQuery.of(context).size.width * 0.9,
//           child: DefaultButton(
//             text: "Add new item",
//             onTap: () => Navigator.pushNamed(context, AppRouter.addItemRoute),
//           ),
//         ),
//       ),
//       body: ValueListenableBuilder<Box<Product>>(
//         valueListenable: Hive.box<Product>(productBoxName).listenable(),
//         builder: (context, box, child) {
//           final products = box.values.toList();
//           return products.isEmpty
//               ? const Center(child: Text('No products found.'))
//               : ListView.builder(
//                   itemCount: products.length,
//                   itemBuilder: (context, index) {
//                     final product = products[index];
//                     return InkWell(
//   onTap: () async {
//     final imagePath = await FileUtils.getFullImagePath(product.relativeImagePath);
//     if(imagePath != null){
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductDetailPage(productId: product.id),
//           ),
//         );
//     }
//   },
//   child: ListTile(
//     title: Text(product.name),
//     leading: FutureBuilder<String?>( // Note the String? type
//   future: FileUtils.getDocumentsPathByRelativePath(product.relativeImagePath),
//   builder: (context, snapshot) {
//     if (snapshot.hasData) {
//       final imagePath = snapshot.data; // imagePath can be null
//       return imagePath != null
//           ? Image.file(File(imagePath))
//           : const Icon(Icons.image_not_supported); // Or a more appropriate widget
//     } else if (snapshot.hasError) {
//       return const Icon(Icons.error);
//     } else {
//       return const CircularProgressIndicator();
//     }
//   },
// ),
//   ),
// );
//                   },
//                 );
//         },
//       ),
//     );
//   }
// }