import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/presentation/history/add_place.dart';
import 'package:test_scav/presentation/home/edit_item.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/widgets/color_box.dart';
import 'package:test_scav/widgets/default_button.dart'; 


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
            return const Scaffold(body: Center(child: Text('Item not found')));
          }
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditItemPage(itemData: item),
                    ),
                  );
                },
                child: const Text('Edit Item'),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DefaultButton(
                text: 'Add',
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
                  if (item.photoUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        File(item.photoUrl!),
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.9,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 16.0),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20)),
                    height: MediaQuery.of(context).size.height * 0.09,
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
                            height: MediaQuery.of(context).size.height * 0.09,
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
                        height: MediaQuery.of(context).size.height * 0.09,
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
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20)),
                        height: MediaQuery.of(context).size.height * 0.09,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Description',
                                style: AppFonts.h6,
                              ),
                              // SizedBox(height: 5,),
                              Text(item.description),
                            ],
                          ),
                        )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}