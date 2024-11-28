import 'package:flutter/material.dart';
import 'package:test_scav/data/models/tips/tips_data.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/widgets/left_button.dart';


class TipPage extends StatelessWidget {
  final Tip tip;
  const TipPage({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tip',style: AppFonts.h10,),
        centerTitle: true,
        leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: LeftButton(
                icon: Icons.arrow_left,
                onTap: () {
                  Navigator.pop(context);
                },
                iconColor: Colors.black,
                backgroundColor: Colors.transparent,
                borderColor: Colors.black12,
              ),
            ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (tip.photo != null) ...[
                ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(tip.photo!,
                    height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 0.9,
                            fit: BoxFit.cover
                    )),
                const SizedBox(height: 16),
              ],

              Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20)),
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.9,

                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip.header ?? "Tip",
                          style: AppFonts.h8,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          tip.firstPoint ?? '',
                          style: AppFonts.h6,
                        ),
                        Text(tip.secondPoint ?? '',
                        style: AppFonts.h6,
                        ),
                        const SizedBox(height: 16),
                        Text(tip.thirdPoint ?? '',
                        style: AppFonts.h6,
                        ),
                        const SizedBox(height: 16),
                        Text(tip.forthPoint ?? '',
                        style: AppFonts.h6,
                        ),
                      ],
                    ),
                  )),
        
            ],
          ),
        ),
      ),
    );
  }
}
