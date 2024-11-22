import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/presentation/home/item_detail_page.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';

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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ItemDetailPage(itemId: itemId.id)),
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (itemId.photoUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(File(itemId.photoUrl!),
                        height: 146, width: 146, fit: BoxFit.cover),
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
                    const SizedBox(height: 15),
                    Row(
                          children: [
                            const Icon(
                              Icons.color_lens_outlined,
                              size: 25,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              itemId.color,
                              
                            ),
                          ],
                        ),
                      const SizedBox(height: 15),  
                      Row(
                          children: [
                            const Icon(
                              Iconsax.box_1,
                              size: 25,
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
