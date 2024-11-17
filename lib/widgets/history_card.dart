import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:test_scav/models/history_data.dart';
import 'package:test_scav/presentation/history/detail_history.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';

class HistoryCard extends StatelessWidget {
  final HistoryData item;
  const HistoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.9,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {

        Future.delayed(Duration.zero, (){Navigator.of(context)
            .push(DetailHistoryPage.materialPageRoute(itemId: item.id));});
        
      },

          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.lightBorderGray,
              ),
            ),
            child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.photoUrl != null)
                        Image.file(File(item.photoUrl!), height: 146, width: 146, fit: BoxFit.cover),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text(item.itemName, style: AppFonts.h6,),
                        const SizedBox(height: 10.0),
                        
                        // Text(formattedDateTime),
                        Row(
                          children: [
                            const Icon(Iconsax.calendar_1, size: 25,),
                            const SizedBox(width: 5,),
                            Text(item.formattedFetchDate, ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            const Icon(Iconsax.clock),
                            const SizedBox(width: 5,),
                            Text(item.formattedFetchTime),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            const Icon(Iconsax.location),
                            const SizedBox(width: 5,),
                            Text(item.placeName),
                          ],
                        ),
                                        
                        ],),
                      ),
                      
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
