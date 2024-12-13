
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
  final String appDocumentsDirPath;
  const MyItemsPage({Key? key, required this.appDocumentsDirPath})
      : super(key: key);

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
    itemBox = Hive.box<ItemData>(itemBoxName);
    reminderBox = Hive.box<Reminder>(reminderBoxName);
    _updateReminderTitles();
    reminderBox.listenable().addListener(_updateReminderTitles);
  }

  void _updateReminderTitles() {
    try {
      final titles = [
        'All',
        ...reminderBox.values.map((reminder) => reminder.title)
      ];
      _reminderTitles.value = titles;
    } catch (e) {
      print("Error updating reminder titles: $e");
    }
  }

  List<ItemData> _sortItemsByGroup(List<ItemData> items) {
    return items
        .where((item) => item.group == selectedGroup || selectedGroup == 'All')
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
    itemBox.close();
    reminderBox.listenable().removeListener(_updateReminderTitles);
    _reminderTitles.dispose();
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
                    padding: const EdgeInsets.symmetric(horizontal: 7.0),
                    child: _buildDropdown(reminderTitles),
                  );
                },
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 20, right: 20),
            child: DefaultButton(
                    text: "Add new item",
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRouter.addItemRoute);
                    }),
          ),
          
       
          body: items.isEmpty
            ? const Center(
                child: Text('Your items will be here', style: AppFonts.h8))
            : items.isEmpty
            ? const Center(child: Text('Your items will be here'))
            : SingleChildScrollView( // Wrap with SingleChildScrollView
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedItems.length,
                itemBuilder: (context, index) {
                  final item = sortedItems[index];
                  return ItemCard(
                    key: ValueKey(item.id),
                    itemId: item,
                  );
                },
              )));
      },
    );
  }

  Widget _buildDropdown(List<String> reminderTitles) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      width: MediaQuery.of(context).size.width * 0.40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
            color: AppColors.gray, style: BorderStyle.solid, width: 1),
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
}
