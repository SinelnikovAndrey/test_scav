import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/models/item_data.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/app_router.dart';
import 'package:test_scav/widgets/default_button.dart';

class ItemDetailPage extends StatefulWidget {
  final String itemId;
  const ItemDetailPage({super.key, required this.itemId});

  static MaterialPageRoute materialPageRoute({
    required String itemId,
  }) =>
      MaterialPageRoute(
          builder: (context) => ItemDetailPage(
                itemId: itemId,
              ));

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  ItemData? item;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItemData();
  }

  Future<void> _loadItemData() async {
    final box = await Hive.openBox<ItemData>(itemBoxName);
    final loadedItem = box.get(widget.itemId);
    setState(() {
      item = loadedItem;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
       
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 30,
        ),
        child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: 
                      
                      DefaultButton(
                  text: 'Add',
                  onTap: () {
                          Navigator.of(context).pushNamed(AppRouter.addItemRoute);
                        },
                )
               
                    ),
      ),
      body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item!.photoUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(File(item!.photoUrl!),
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 0.9,
                            fit: BoxFit.cover),
                      ),
                    const SizedBox(height: 16.0),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Form',style: AppFonts.h6,),
                            // SizedBox(height: 5,),
                            Text(item!.form),
                          ],
                        ),
                      )),
                       const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20)
                          ),
                           height: MediaQuery.of(context).size.height * 0.09,
                            width: MediaQuery.of(context).size.width * 0.68,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Color',style: AppFonts.h6,),
                                
                                Text(item!.color),
                                
                              ],
                            ),
                          )),
                          const SizedBox(width: 10.0),
                          ColorBox(color: colorMap[item!.color]!)
                        ],
                      ),
                       const SizedBox(height: 16.0),
                      Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Group',style: AppFonts.h6,),
                            // SizedBox(height: 5,),
                            Text(item!.group),
                          ],
                        ),
                      )),
                       const SizedBox(height: 16.0),
                      Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Description',style: AppFonts.h6,),
                            // SizedBox(height: 5,),
                            Text(item!.description),
                          ],
                        ),
                      )),
                  ],
                ),
              ),
            ));
  }
}

class ColorBox extends StatelessWidget {
  final Color color;

  const ColorBox({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.09,
      width: MediaQuery.of(context).size.width * 0.20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}