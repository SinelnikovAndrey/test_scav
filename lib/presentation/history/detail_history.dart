import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/data/models/history_data.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/presentation/history/edit_history.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/file_utils.dart';
import 'package:test_scav/widgets/left_button.dart';


class HistoryDetailPage extends StatelessWidget {
  final String itemId;
  const HistoryDetailPage({super.key, required this.itemId});

   @override
Widget build(BuildContext context) {
  return ValueListenableBuilder<Box<HistoryData>>(
    valueListenable: Hive.box<HistoryData>(historyBoxName).listenable(),
    builder: (context, box, _) {
      final item = box.get(itemId);
      if (item == null) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator())); 
        } else {
        return  Scaffold(
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
                    borderRadius: BorderRadius.circular(10),
                    child: FutureBuilder<String>(
                      future: FileUtils.getFullImagePath(
                      item.relativeImagePath,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.file(
                            File(
                              snapshot.data!,
                            ),
                            width: MediaQuery.of(context).size.width * 0.9,
                          );
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
                              'Date',
                              style: AppFonts.h6,
                            ),
                            // SizedBox(height: 5,),
                            Text(item.formattedFetchDate),
                          ],
                        ),
                      )),
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
                              'Time',
                              style: AppFonts.h6,
                            ),
                            // SizedBox(height: 5,),
                            Text(item.formattedFetchTime),
                          ],
                        ),
                      )),
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
                              'Location',
                              style: AppFonts.h6,
                            ),
                            // SizedBox(height: 5,),
                            Text(item.placeName),
                          ],
                        ),
                      )),
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
                              'Description',
                              style: AppFonts.h6,
                            ),
                            // SizedBox(height: 5,),
                            Text(item.placeDescription),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                   if (item.relativeImagePath != null &&
                    item.relativeImagePath!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FutureBuilder<String>(
                      future: FileUtils.getFullImagePath(
                          item.placePhotoUrl!),
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
                ],
              ),
            ),
          ),
        );
      }});
    
  }

}