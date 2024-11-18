import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/data/models/history_data.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/presentation/history/add_place.dart';
import 'package:test_scav/presentation/history/edit_history.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/widgets/default_button.dart';

class HistoryDetailPage extends StatelessWidget {
  final String historyId;
  const HistoryDetailPage({super.key, required this.historyId});





  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<HistoryData>>(
      valueListenable: Hive.box<HistoryData>(historyBoxName).listenable(),
      builder: (context, box, _) {
        final item = box.get(historyId);
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
                      builder: (context) => EditHistoryPage(placeData: item),
                    ),
                  );
                },
                child: const Text('Edit Item'),
              ),
            ],
          ),
        
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.photoUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(File(item.photoUrl!),
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.9,
                          fit: BoxFit.cover),
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
                      height: MediaQuery.of(context).size.height * 0.09,
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
                            Text(item.formattedFetchDate),
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
                            Text(item.placeDescription),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  if (item.placePhotoUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(File(item.placePhotoUrl!),
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.9,
                          fit: BoxFit.cover),
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
