import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_scav/my_app.dart';
import 'package:test_scav/presentation/tips/tip_card.dart';
import 'package:test_scav/utils/app_fonts.dart';

class TipDisplay extends StatelessWidget {
  const TipDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context); // Get AppData

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Tips', style: AppFonts.h10),
          ],
        ),
      ),
      body: appData.rootData.tips == null || appData.rootData!.tips!.isEmpty
          ? const Center(child: Text('No tips found.'))
          : ListView.builder(
              itemCount: appData.rootData.tips!.length,
              itemBuilder: (context, index) {
                final tip = appData.rootData.tips![index];
                if (tip == null) return const SizedBox.shrink();
                return TipCard(tip: tip);
              },
            ),
    );
  }
}