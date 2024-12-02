import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/presentation/home/item_detail_page.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/assets.dart';
import 'package:test_scav/utils/file_utils.dart';

class ItemCard extends StatelessWidget {
  final ItemData itemId;
  const ItemCard({super.key, required this.itemId});

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
            print('Product object: $itemId');
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemDetailPage(itemId: itemId.id)),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.lightBorderGray),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Improved Image handling
                if (itemId.relativeImagePath != null &&
                    itemId.relativeImagePath!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FutureBuilder<String>(
                      future: FileUtils.getFullImagePath(
                          itemId.relativeImagePath!), 
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                              height: 100,
                              width: 100,
                              child: Center(
                                  child: CircularProgressIndicator()));
                        } else if (snapshot.hasError) {
                          return const Icon(Icons.error);
                        } else if (snapshot.hasData &&
                            snapshot.data!.isNotEmpty) {
                          return Image.file(
                            File(snapshot.data!),
                            // height:
                            //     MediaQuery.of(context).size.height * 0.15, 
                            width: MediaQuery.of(context).size.width * 0.5, 
                            fit: BoxFit.cover,
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  )
                else
                  const Icon(
                    Icons.inventory,
                    size: 100,
                    color: AppColors.primary,
                  ),
                const SizedBox(width: 25),
                // title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemId.name,
                      maxLines: 1,
                      style: AppFonts.h8,
                    ),
                   SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    Row(
                          children: [
                             SvgPicture.asset(
                SvgAssets.colorLens,
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              itemId.color,
                              
                            ),
                          ],
                        ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02,), 
                      Row(
                          children: [
                             SvgPicture.asset(
                SvgAssets.cube,
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              itemId.form,
                            ),
                          ],
                        ),
             
                  ],
                ),

                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
