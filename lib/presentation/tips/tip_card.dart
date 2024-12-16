import 'package:flutter/material.dart';
import 'package:test_scav/data/models/tips/tips_data.dart';
import 'package:test_scav/presentation/tips/tip_page.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';

class TipCard extends StatelessWidget {
  final Tip tip;

  const TipCard({Key? key, required this.tip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 178,
        width: 382,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TipPage(tip: tip), 
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.lightBorderGray,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all( 5.0),
              child: Row(
             
                children: [
                  if (tip.photo != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(tip.photo!,
                          height: 146,
                          width: 146,
                       fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                        return const Text(
                            'Image not found');
                      }),
                    )
                  ],
                   const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              
                      Expanded(
                        child: SizedBox(
                          width: 175,
                          height: 10,

                          child: Text(
                            tip.header ?? 'No Header',
                            style: AppFonts.h8,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.left
                          ),
                        ),
                      ),
                      // const SizedBox(height: 8),
                      Expanded(
                        child: SizedBox(
                          width: 175,

                          child: Text(
                            style: AppFonts.h6,
                            tip.firstPoint ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            textAlign: TextAlign.left
                          ),
                        ),
                      ),
                    
                
                      const SizedBox(height: 15),
                    ],
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





