import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:test_scav/data/models/history_data.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/my_app.dart';
import 'package:test_scav/presentation/history/edit_history.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/file_utils.dart';
import 'package:test_scav/widgets/left_button.dart';
import 'package:path/path.dart' as p;

class HistoryDetailPage extends StatelessWidget {
  final String itemId;
  const HistoryDetailPage({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    final appDocumentsDirPath =
        Provider.of<AppData>(context).appDocumentsDirPath;
    return ValueListenableBuilder<Box<HistoryData>>(
        valueListenable: Hive.box<HistoryData>(historyBoxName).listenable(),
        builder: (context, box, _) {
          final item = box.get(itemId);
          if (item == null) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  item.itemName,
                  style: AppFonts.h10,
                ),
                automaticallyImplyLeading: false,
                centerTitle: true,
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
                            builder: (context) => EditHistoryPage(
                              placeData: item,
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
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.relativeImagePath.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            height: 382,
                            width: 382,
                            fit: BoxFit.cover,
                            File(p.join(
                              appDocumentsDirPath,
                              item.relativeImagePath,
                            )),
                          ),
                        ),
                      const SizedBox(height: 16.0),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(20)),
                          height: 88,
                          width: 382,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Date',
                                  style: AppFonts.h8,
                                ),
                                const SizedBox(height: 5,),
                                Text(item.formattedFetchDate,style: AppFonts.h6,),
                              ],
                            ),
                          )),
                      const SizedBox(height: 16.0),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(20)),
                          height: 88,
                          width: 382,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Time',
                                  style: AppFonts.h8,
                                ),
                                const SizedBox(height: 5,),
                                Text(item.formattedFetchTime,style: AppFonts.h6,),
                              ],
                            ),
                          )),
                      const SizedBox(height: 16.0),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(20)),
                          height: 88,
                          width: 382,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Location',
                                  style: AppFonts.h8,
                                ),
                                const SizedBox(height: 5,),
                                Text(item.placeName,style: AppFonts.h6,),
                              ],
                            ),
                          )),
                      const SizedBox(height: 16.0),
                      if (item.placeDescription.isNotEmpty)
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(20)),
                          // height: 88,
                          width: 382,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,vertical: 13),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Description',
                                  style: AppFonts.h8,
                                ),
                                const SizedBox(height: 5,),
                                Text(item.placeDescription,style: AppFonts.h6,) ,

                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      if (item.placePhotoUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            height: 382,
                          width: 382,
                          fit: BoxFit.cover,
                            File(p.join(
                              
                                appDocumentsDirPath, item.placePhotoUrl!)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
