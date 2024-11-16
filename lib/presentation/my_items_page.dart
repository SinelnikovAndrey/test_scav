
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/models/item_data.dart';
import 'package:test_scav/utils/app_router.dart';
import 'package:test_scav/widgets/default_button.dart';
import 'package:test_scav/widgets/item_card.dart';

class MyItemsPage extends StatefulWidget {
  const MyItemsPage({Key? key}) : super(key: key);

  @override
  State<MyItemsPage> createState() => _MyItemsPageState();
}

class _MyItemsPageState extends State<MyItemsPage> {
  List<ItemData> items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() {
      isLoading = true;
    });
    try {
      final box = await Hive.openBox<ItemData>(itemBoxName);
      items = box.values.toList();
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading items: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Items')),
      bottomNavigationBar: DefaultButton(
            text: "Add",
            onTap: () {
              Navigator.of(context).pushNamed(AppRouter.addItemRoute);
            }),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            child: GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Column(
                    children: [
                      // best selling
                      if (items.isNotEmpty) ...[
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: 
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            // padding: const EdgeInsets.symmetric(horizontal: 25),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return Row(
                                
                                children: [
                                  Flexible(
                                    child: ItemCard(
                                      item: items[index],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
          ),


    );
  }
}

