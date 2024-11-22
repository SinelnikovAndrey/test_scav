import 'package:flutter/material.dart';
import 'package:test_scav/data/models/tips/tips_data.dart';
import 'package:test_scav/presentation/tips/tip_card.dart';
import 'package:test_scav/utils/app_fonts.dart';


class TipDisplay extends StatelessWidget {
  final Root rootData;

  const TipDisplay({Key? key, required this.rootData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: const Text('Tips',style: AppFonts.h10,),
        centerTitle: true,
      ),
      body: rootData.tips == null || rootData.tips!.isEmpty
          ? const Center(child: Text('No tips found.')) 
          : ListView.builder(
              itemCount: rootData.tips!.length,
              itemBuilder: (context, index) {
                final tip = rootData.tips![index];
                if (tip == null) return const SizedBox.shrink(); 
                return TipCard(tip: tip);
              },
            ),
    );
  }
}