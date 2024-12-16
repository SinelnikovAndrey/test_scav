import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/my_app.dart';
import 'package:test_scav/presentation/history/add_place.dart';
import 'package:test_scav/presentation/home/edit_item.dart';
import 'package:test_scav/presentation/home/my_items_page.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/app_router.dart';
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
    final appDocumentsDirPath =
        Provider.of<AppData>(context).appDocumentsDirPath;

    return ValueListenableBuilder<Box<ItemData>>(
      valueListenable: Hive.box<ItemData>(itemBoxName).listenable(),
      builder: (context, box, _) {
        final item = box.get(itemId);
        if (item == null) {
          return const Scaffold(body: Center(child: Text('Item not found')));
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

          
          bottomSheet: Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 20, right: 20),
            child: DefaultButton(
              text: "Got it!",
              onTap: () {
            
                 Navigator.pushReplacementNamed(
          context,
          AppRouter.addPlaceRoute,
           arguments: {
                
                    'itemId': item.id,
                  }
        );
                
              },
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
                      child: Image.file(
                        height: 382,
                        width: 382,
                        fit: BoxFit.cover,
                        File(p.join(appDocumentsDirPath,
                            item.relativeImagePath!)), // Use the cached path
                      ),
                    ),
                  const SizedBox(height: 16.0),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20)),
                    height: 82,
                    width: 382,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Form',
                            style: AppFonts.h8,
                          ),
                          Text(item.form,
                              style: AppFonts.h6,
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)),
                      height: 82,
                      width: 382,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Color',
                                  style: AppFonts.h8,
                                ),
                                Text(item.color,
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                            const Spacer(),
                            ColorBox(
                                height: 50,
                                width: 50,
                                color: colorMap[item.color]!)
                          ],
                        ),
                      )),
                  const SizedBox(height: 16.0),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)),
                      height: 82,
                      width: 382,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Group',
                              style: AppFonts.h8,
                              
                            ),
                            // SizedBox(height: 5,),
                            Text(
                              item.group,
                              style: AppFonts.h6,
                              maxLines: 1,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 16.0),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)),
                      height: 82,
                      width: 382,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Description',
                              style: AppFonts.h8,
                            ),
                            // SizedBox(height: 5,),
                            Text(
                              item.description,
                              style: AppFonts.h6,
                              maxLines: 1,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
