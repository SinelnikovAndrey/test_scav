import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/presentation/history/add_place.dart';
import 'package:test_scav/presentation/home/edit_item.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/file_utils.dart';
import 'package:test_scav/widgets/color_box.dart';
import 'package:test_scav/widgets/default_button.dart';
import 'package:test_scav/widgets/left_button.dart';
import 'package:path/path.dart' as p;

class ItemDetailPage extends StatelessWidget {
  final String itemId;
  const ItemDetailPage({super.key, required this.itemId});

  @override
Widget build(BuildContext context) {
  return ValueListenableBuilder<Box<ItemData>>(
    valueListenable: Hive.box<ItemData>(itemBoxName).listenable(),
    builder: (context, box, _) {
      final item = box.get(itemId);
      if (item == null) {
        return const Scaffold(
            body: Center(child: Text('Item not found')));
      }

      final itemDataNotifier = ValueNotifier(item); 

      return Scaffold(
        appBar: AppBar(
          title: Text(
            item.name,
            style: AppFonts.h10,
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: LeftButton(
              icon: Icons.arrow_left,
              onTap: () {
                Navigator.pop(context);
              },
              iconColor: Colors.black,
              backgroundColor: Colors.transparent,
              borderColor: Colors.black12,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: LeftButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditItemPage(
                        itemData: item,
                        itemDataNotifier: itemDataNotifier,
                      ),
                    ),
                  );
                },
                icon: Icons.edit,
                iconColor: Colors.black,
                backgroundColor: Colors.transparent,
                borderColor: Colors.black12,
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,
            child: DefaultButton(
              text: "Got it!",
              onTap: () {
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).push(
                      AddPlacePage.materialPageRoute(itemId: item.id));
                });
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            
                if (item.relativeImagePath != null &&
                    item.relativeImagePath!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FutureBuilder<String>(
                      future: FileUtils.getFullImagePath(
                          item.relativeImagePath!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.file(File(snapshot.data!));
                        } else if (snapshot.hasError) {
                          return const Icon(Icons.error);
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20)),
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Form',
                            style: AppFonts.h6,
                          ),
                          Text(item.form),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(20)),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.68,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Color',
                                  style: AppFonts.h6,
                                ),
                                Text(item.color),
                              ],
                            ),
                          )),
                      const SizedBox(width: 10.0),
                      ColorBox(color: colorMap[item.color]!)
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)),
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Group',
                              style: AppFonts.h6,
                            ),
                            // SizedBox(height: 5,),
                            Text(item.group),
                          ],
                        ),
                      )),
                  const SizedBox(height: 16.0),
                  TextField(
                    title: 'Description',
                    value: item.description,
                  ),
                   SizedBox(height: MediaQuery.of(context).size.height * 0.15,),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TextField extends StatelessWidget {
  const TextField({
    super.key,
    // required this.item,
    required this.title,
    required this.value,
  });

  // final ItemData item;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(20)),
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppFonts.h6,
              ),
              // SizedBox(height: 5,),
              Text(
                value,
                // '$item.$value'
              ),
            ],
          ),
        ));
  }
}
