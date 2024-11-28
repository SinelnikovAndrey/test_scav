

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/data/models/history_data.dart';
import 'package:test_scav/presentation/history/widgets/history_card.dart';
import 'package:test_scav/utils/app_fonts.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Box<HistoryData> placeBox;

  @override
  void initState() {
    super.initState();
    placeBox = Hive.box<HistoryData>(historyBoxName);
  }

  @override
  void dispose() {
    placeBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History',style: AppFonts.h10,),
        centerTitle: true,

      ),
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: placeBox.listenable(),
            builder: (context, Box<HistoryData> box, widget) {
              final places = box.values.toList();
          
              if (places.isEmpty) {
                return const Center(child: Text('The history of your items will be here', style: AppFonts.h8));
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      final placeData = places[index];
                            
                      return HistoryCard(
                              key: ValueKey(places[index].id),
                              item: places[index],
                            );
                    },
                  ),
                );
              }
            },
          ),
          // SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
        ],
      ),
    );
  }
}





