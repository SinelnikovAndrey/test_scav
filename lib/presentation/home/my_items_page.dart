import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/presentation/home/item_detail_page.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/app_router.dart';
import 'package:test_scav/utils/assets.dart';
import 'package:test_scav/utils/file_utils.dart';
import 'package:test_scav/widgets/default_button.dart';
import 'package:test_scav/presentation/home/widgets/item_card.dart';
import 'package:test_scav/widgets/round_button.dart';

class MyItemsPage extends StatefulWidget {
  final String appDocumentsDirPath;
  const MyItemsPage({Key? key,required this.appDocumentsDirPath}) : super(key: key);

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
    reminderBox = Hive.box<Reminder>(reminderBoxName);
    _updateReminderTitles();
    reminderBox.listenable().addListener(_updateReminderTitles);
  }

  void _updateReminderTitles() {
    try {
      final titles = ['All', ...reminderBox.values.map((reminder) => reminder.title)];
      _reminderTitles.value = titles;
    } catch (e) {
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
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.9,
              child: DefaultButton(text: "Add new item", onTap: () {
                Navigator.of(context).pushNamed(AppRouter.addItemRoute);
              }),
            ),
          ),
          body: items.isEmpty
              ? const Center(child: Text('Your items will be here', style: AppFonts.h8))
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
                              return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.9,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            print('Product object: $item');
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemDetailPage(itemId: item.id)),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.lightBorderGray),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Improved Image handling
                if (item.relativeImagePath != null &&
                    item.relativeImagePath!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FutureBuilder<String>(
                      future: FileUtils.getFullImagePath(
                          item.relativeImagePath!), 
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                              height: 100,
                              width: 100,
                              child: Center(
                                  child: CircularProgressIndicator()));
                        } else if (snapshot.hasError) {
                          return const Icon(Icons.error);
                        } else if (snapshot.hasData &&
                            snapshot.data!.isNotEmpty) {
                          return Image.file(
                            File(snapshot.data!),
                            height:
                                MediaQuery.of(context).size.height * 0.25, 
                            width: MediaQuery.of(context).size.width * 0.4, 
                            fit: BoxFit.cover,
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  )
                else
                  const Icon(
                    Icons.inventory,
                    size: 100,
                    color: AppColors.primary,
                  ),
                const SizedBox(width: 25),
                // title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      style: AppFonts.h8,
                    ),
                   SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    Row(
                          children: [
                             SvgPicture.asset(
                SvgAssets.colorLens,
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              item.color,
                              
                            ),
                          ],
                        ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02,), 
                      Row(
                          children: [
                             SvgPicture.asset(
                SvgAssets.cube,
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              item.form,
                            ),
                          ],
                        ),
             
                  ],
                ),

                
              ],
            ),
          ),
        ),
      ),
    );
                            },
                          ),
                        ),
                         SizedBox(height: MediaQuery.of(context).size.height * 0.35,),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildDropdown(List<String> reminderTitles) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      width: MediaQuery.of(context).size.width * 0.40,
      
      
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

}

