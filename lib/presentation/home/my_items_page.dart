import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/app_router.dart';
import 'package:test_scav/widgets/default_button.dart';
import 'package:test_scav/presentation/home/widgets/item_card.dart';
import 'package:test_scav/widgets/round_button.dart';

class MyItemsPage extends StatefulWidget {
  const MyItemsPage({Key? key}) : super(key: key);

  @override
  State<MyItemsPage> createState() => _MyItemsPageState();
}

class _MyItemsPageState extends State<MyItemsPage> {
    late final Box<ItemData> itemBox;
  late final Box<Reminder> reminderBox;
  String? selectedGroup = 'All';
  final ValueNotifier<List<String>> _reminderTitles = ValueNotifier(['All']);

  @override
  void initState() {
    super.initState();
    // ... other init code ...
    reminderBox = Hive.box<Reminder>(reminderBoxName);
    _updateReminderTitles(); // Initial load
    reminderBox.listenable().addListener(_updateReminderTitles); // Listen for changes
  }

  void _updateReminderTitles() {
    try {
      final titles = ['All', ...reminderBox.values.map((reminder) => reminder.title)];
      _reminderTitles.value = titles;
    } catch (e) {
      //Handle errors appropriately, perhaps by showing a message.
      print("Error updating reminder titles: $e");
    }
  }

   List<ItemData> _sortItemsByGroup(List<ItemData> items) {
    return items.where((item) => item.group == selectedGroup || selectedGroup == 'All').toList();
  }

  @override
  void dispose() {
    super.dispose();
     itemBox.close();
    reminderBox.listenable().removeListener(_updateReminderTitles); //Remove listener to avoid leaks.
    _reminderTitles.dispose(); 
    // ... other dispose code ...
  }

 



   @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<ItemData>>(
      valueListenable: Hive.box<ItemData>(itemBoxName).listenable(),
      builder: (context, itemBox, child) {
        final items = itemBox.values.toList();
        final sortedItems = _sortItemsByGroup(items);
        return Scaffold(
          appBar: AppBar(
            title: const Text('MyItems', style: AppFonts.h9),
            automaticallyImplyLeading: false,
            actions: [
                        RoundButton(
              icon: Icons.add,
              onTap: () {
                Navigator.of(context).pushNamed(AppRouter.addGroupRoute);
              }),
              ValueListenableBuilder<List<String>>(
                valueListenable: _reminderTitles,
                builder: (context, reminderTitles, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: _buildDropdown(reminderTitles), //Helper function from before
                  );
                },
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width * 0.9,
              child: DefaultButton(text: "Add", onTap: () {
                Navigator.of(context).pushNamed(AppRouter.addItemRoute);
              }),
            ),
          ),
          body: sortedItems.isEmpty
              ? const Center(child: Text('Your items will be here', style: AppFonts.h8))
              : SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: sortedItems.length,
                      itemBuilder: (context, index) {
                        final item = sortedItems[index];
                        return ItemCard(key: ValueKey(item.id), itemId: item);
                      },
                    ),
                  ),
                ),
        );
      },
    );
  }

  //Helper function to avoid repeated code in ValueListenableBuilder
  Widget _buildDropdown(List<String> reminderTitles) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      width: MediaQuery.of(context).size.width * 0.37,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: AppColors.gray, style: BorderStyle.solid, width: 1),
      ),
      child: DropdownButton<String>(
        underline: const SizedBox(),
        value: selectedGroup,
        hint: const Text('Select Group'),
        items: reminderTitles.map((title) {
          return DropdownMenuItem<String>(
            value: title,
            child: Text(title),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedGroup = value;
          });
        },
      ),
    );
  }

  // ... rest of your code (initState, dispose, etc.) ...
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('MyItems', style: AppFonts.h9,),
//         automaticallyImplyLeading: false,
//         // centerTitle: true,
//         actions: [
          // RoundButton(
          //     icon: Icons.add,
          //     onTap: () {
          //       Navigator.of(context).pushNamed(AppRouter.addGroupRoute);
          //     }),
   
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15.0),
//             child: ValueListenableBuilder<List<String>>( // ValueListenableBuilder
//               valueListenable: _reminderTitles,
//               builder: (context, reminderTitles, child) {
//                 return Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                     width: MediaQuery.of(context).size.width * 0.37,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15.0),
//                       border: Border.all(
//                           color: AppColors.gray,
//                           style: BorderStyle.solid,
//                           width: 1),
//                     ),
//                   child: DropdownButton<String>(
//                     underline: const SizedBox(),
//                     value: selectedGroup,
//                     hint: const Text('Select Group'),
//                     items: reminderTitles.map((title) {
//                       return DropdownMenuItem<String>(
//                         value: title,
//                         child: Text(title),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedGroup = value;
//                       });
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(right: 5.0),
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height * 0.09,
//           width: MediaQuery.of(context).size.width * 0.9,
//           child: DefaultButton(
//               text: "Add",
//               onTap: () {
//                 Navigator.of(context).pushNamed(AppRouter.addItemRoute);
//               }),
//         ),
//       ),
//       body: ValueListenableBuilder<Box<ItemData>>(
//         valueListenable: Hive.box<ItemData>(itemBoxName).listenable(),
//         builder: (context, box, child) {
//           final items = box.values.toList();
//           final sortedItems = _sortItemsByGroup(items);
//           return sortedItems.isEmpty
//               ? const Center(child: Text('Your items will be here', style: AppFonts.h8,))
//               : SingleChildScrollView(
//                   child: SizedBox(
//                     height: MediaQuery.of(context).size.height,
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: sortedItems.length,
//                             itemBuilder: (context, index) {
//                               final item = sortedItems[index];
//                               return ItemCard(
//                                 key: ValueKey(item.id),
//                                 itemId: item,
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//         },
//       ),
//     );
//   }
// }
