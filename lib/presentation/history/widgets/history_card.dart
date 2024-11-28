import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_scav/data/models/history_data.dart';
import 'package:test_scav/presentation/history/detail_history.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/assets.dart';

class HistoryCard extends StatelessWidget {
  final HistoryData item;
  const HistoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width * 0.9,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HistoryDetailPage(historyId: item.id)),
            );
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
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(File(item.photoUrl!),
                            height: MediaQuery.of(context).size.height * 0.20,
                             width: MediaQuery.of(context).size.width * 0.40,
                            fit: BoxFit.cover)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.itemName,
                          style: AppFonts.h8,
                        ),
                         SizedBox(height: MediaQuery.of(context).size.height * 0.01,),

                        // Text(formattedDateTime),
                        Row(
                          children: [
                           SvgPicture.asset(
                SvgAssets.calendar,
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              item.formattedFetchDate,
                            ),
                          ],
                        ),
                         SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                        Row(
                          children: [
                            SvgPicture.asset(
                SvgAssets.timeCircle,
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(item.formattedFetchTime),
                          ],
                        ),
                         SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                        Row(
                          children: [
                            SvgPicture.asset(
                SvgAssets.location,
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(item.placeName),
                          ],
                        ),
                      ],
                    ),
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
