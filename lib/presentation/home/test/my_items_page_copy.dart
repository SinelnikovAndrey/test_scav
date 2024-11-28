// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:test_scav/data/product.dart';
// import 'package:test_scav/main.dart';
// import 'package:test_scav/data/models/item_data.dart';
// import 'package:test_scav/data/models/reminder/reminder.dart';
// import 'package:test_scav/utils/app_colors.dart';
// import 'package:test_scav/utils/app_fonts.dart';
// import 'package:test_scav/utils/app_router.dart';
// import 'package:test_scav/utils/file_utils.dart';
// import 'package:test_scav/widgets/default_button.dart';
// import 'package:test_scav/presentation/home/widgets/item_card.dart';
// import 'package:test_scav/widgets/round_button.dart';

// class MyItemsPageCopy extends StatefulWidget {
//   const MyItemsPageCopy ({Key? key}) : super(key: key);

//   @override
//   State<MyItemsPageCopy > createState() => _MyItemsPageCopyState();
// }

// class _MyItemsPageCopyState extends State<MyItemsPageCopy > {
//     late final Box<ItemData> itemBox;
//   late final Box<Reminder> reminderBox;
//   String? selectedGroup = 'All';
//   final ValueNotifier<List<String>> _reminderTitles = ValueNotifier(['All']);

//   @override
//   void initState() {
//     super.initState();
//     reminderBox = Hive.box<Reminder>(reminderBoxName);
//     _updateReminderTitles();
//     reminderBox.listenable().addListener(_updateReminderTitles);
//   }

//   void _updateReminderTitles() {
//     try {
//       final titles = ['All', ...reminderBox.values.map((reminder) => reminder.title)];
//       _reminderTitles.value = titles;
//     } catch (e) {
//       print("Error updating reminder titles: $e");
//     }
//   }

//    List<ItemData> _sortItemsByGroup(List<ItemData> items) {
//     return items.where((item) => item.group == selectedGroup || selectedGroup == 'All').toList();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//      itemBox.close();
//     reminderBox.listenable().removeListener(_updateReminderTitles); 
//     _reminderTitles.dispose(); 
  
//   }

 



//    @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<Box<Product>>(
//         valueListenable: Hive.box<Product>(productBoxName).listenable(),
//         builder: (context, box, child) {
//           final products = box.values.toList();
//         // final sortedItems = _sortItemsByGroup(products);
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('MyItems', style: AppFonts.h9),
//             automaticallyImplyLeading: false,
//             actions: [
//                         RoundButton(
//               icon: Icons.add,
//               onTap: () {
//                 Navigator.of(context).pushNamed(AppRouter.addGroupRoute);
//               }),
//               // ValueListenableBuilder<List<String>>(
//               //   valueListenable: _reminderTitles,
//               //   builder: (context, reminderTitles, child) {
//               //     return Padding(
//               //       padding: const EdgeInsets.symmetric(horizontal: 7.0),
//               //       child: _buildDropdown(reminderTitles), 
//               //     );
//               //   },
//               // ),
//             ],
//           ),
//           floatingActionButton: Padding(
//             padding: const EdgeInsets.only(right: 5.0),
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height * 0.1,
//               width: MediaQuery.of(context).size.width * 0.9,
//               child: DefaultButton(text: "Add new item", onTap: () {
//                 Navigator.of(context).pushNamed(AppRouter.addItemRoute);
//               }),
//             ),
//           ),
//           body: products.isEmpty
//               ? const Center(child: Text('Your items will be here', style: AppFonts.h8))
//               : SingleChildScrollView(
//                   child: SizedBox(
//                     height: MediaQuery.of(context).size.height,
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: ListView.builder(
//                   itemCount: products.length,
//                   itemBuilder: (context, index) {
//                     final product = products[index];
//                     return ListTile(
//                       title: Text(product.name),
//                       leading: FutureBuilder<String>(
//                         future: FileUtils.getFullImagePath(product.relativeImagePath),
//                         builder: (context, snapshot) {
//                           if (snapshot.hasData) {
//                             return Image.file(File(snapshot.data!));
//                           } else if (snapshot.hasError) {
//                             return const Icon(Icons.error);
//                           } else {
//                             return const CircularProgressIndicator();
//                           }
//                         },
//                       ),
//                     );
//                   },
//                 ),
//                         ),
//                          SizedBox(height: MediaQuery.of(context).size.height * 0.35,),
//                       ],
//                     ),
//                   ),
//                 ),
//         );
//       },
//     );
//   }

//   Widget _buildDropdown(List<String> reminderTitles) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 5.0),
//       width: MediaQuery.of(context).size.width * 0.40,
      
      
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15.0),
//         border: Border.all(color: AppColors.gray, style: BorderStyle.solid, width: 1),
//       ),
//       child: DropdownButton<String>(
//         underline: const SizedBox(),
//         value: selectedGroup,
//         hint: const Text('Select Group'),
//         items: reminderTitles.map((title) {
//           return DropdownMenuItem<String>(
//             value: title,
//             child: Text(title),
//           );
//         }).toList(),
//         onChanged: (value) {
//           setState(() {
//             selectedGroup = value;
//           });
//         },
//       ),
//     );
//   }

// }

