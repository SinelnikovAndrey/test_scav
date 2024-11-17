import 'dart:io';

import 'package:flutter/material.dart';
import 'package:test_scav/models/item_data.dart';
import 'package:test_scav/presentation/home/item_detail_page.dart';
import 'package:test_scav/utils/app_colors.dart';

class ItemCard extends StatelessWidget {
  final ItemData item;
  const ItemCard({super.key, required this.item});

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
            .push(ItemDetailPage.materialPageRoute(itemId: item.id));});
        
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
                if (item.photoUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(File(item.photoUrl!),
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
                      item.name,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 15),
                    Text(
                  item.name,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                      const SizedBox(height: 15),  
             
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
