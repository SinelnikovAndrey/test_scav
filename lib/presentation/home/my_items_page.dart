import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/presentation/notification/reminder/reminder.dart';
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
  String? selectedGroup;
  late Future<List<String>> _reminderTitlesFuture;

  @override
  void initState() {
    super.initState();
    _reminderTitlesFuture = _fetchReminderTitles();
  }

  Future<List<String>> _fetchReminderTitles() async {
    final box = await Hive.openBox<Reminder>(reminderBoxName);
    return ['All', ...box.values.map((reminder) => reminder.title).toList()];
  }

  List<ItemData> _sortItemsByGroup(List<ItemData> items) {
    if (selectedGroup == null || selectedGroup == 'All') {
      return items;
    }
    return items.where((item) => item.group == selectedGroup).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyItems', style: AppFonts.h9,),
        automaticallyImplyLeading: false,
        // centerTitle: true,
        actions: [
          RoundButton(
              icon: Icons.add,
              onTap: () {
                Navigator.of(context).pushNamed(AppRouter.addGroupRoute);
              }),
   
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: FutureBuilder<List<String>>(
              future: _reminderTitlesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final reminderTitles = snapshot.data!;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: MediaQuery.of(context).size.width * 0.37,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                          color: AppColors.gray,
                          style: BorderStyle.solid,
                          width: 1),
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
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.09,
          width: MediaQuery.of(context).size.width * 0.9,
          child: DefaultButton(
              text: "Add",
              onTap: () {
                Navigator.of(context).pushNamed(AppRouter.newAddItemRoute);
              }),
        ),
      ),
      body: ValueListenableBuilder<Box<ItemData>>(
        valueListenable: Hive.box<ItemData>(itemBoxName).listenable(),
        builder: (context, box, child) {
          final items = box.values.toList();
          final sortedItems = _sortItemsByGroup(items);
          return sortedItems.isEmpty
              ? const Center(child: Text('No items found.'))
              : SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: sortedItems.length,
                            itemBuilder: (context, index) {
                              final item = sortedItems[index];
                              return ItemCard(
                                key: ValueKey(item.id),
                                itemId: item,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
