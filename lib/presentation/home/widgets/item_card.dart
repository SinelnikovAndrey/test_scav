import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/my_app.dart';
import 'package:test_scav/presentation/home/item_detail_page.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/assets.dart';
import 'package:test_scav/utils/file_utils.dart';
import 'package:path/path.dart' as p;

class ItemCard extends StatelessWidget {
  final ItemData itemId;
  const ItemCard({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    final appDocumentsDirPath =
        Provider.of<AppData>(context).appDocumentsDirPath;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 178,
        width: 382,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
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
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.lightBorderGray),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Improved Image handling
                if (itemId.relativeImagePath != null &&
                    itemId.relativeImagePath!.isNotEmpty)
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              height: 146,
                              width: 146,
                              child: Image.file(
                                fit: BoxFit.cover,
                                File(p.join(appDocumentsDirPath,
                                    itemId.relativeImagePath!)),
                              ),
                            ),
                          ),
                        )
                      ])
                else
                  const Icon(
                    Icons.inventory,
                    size: 100,
                    color: AppColors.primary,
                  ),
                const SizedBox(width: 25),
                // title
                SizedBox(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemId.name,
                        maxLines: 1,
                        style: AppFonts.h8,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            SvgAssets.colorLens,
                            
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                         SizedBox(
                            width: 110,
                            child: Text(
                              itemId.color,
                              maxLines: 1,
                              style: AppFonts.h6,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            SvgAssets.cube,
                           
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 110,
                            child: Text(itemId.form,
                                maxLines: 1,
                                style: AppFonts.h6,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis
                                ),
                          ),
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
    );
  }
}
