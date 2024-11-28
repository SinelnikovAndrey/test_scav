// import 'package:flutter/material.dart';
// import 'package:test_scav/presentation/home/test/test_add_item.dart';
// import 'package:test_scav/presentation/home/test/view_products_page.dart';

// class NewMyApp extends StatelessWidget {
//   const NewMyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Product App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(),
//       routes: {
//         '/addProduct': (context) => const AddProductPage(),
//         '/viewProducts': (context) => const ViewProductsPage(),
//       },
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Product App'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/addProduct');
//               },
//               child: const Text('Add Product'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/viewProducts');
//               },
//               child: const Text('View Products'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }