import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/presentation/notification/reminder/reminder.dart';
import 'package:test_scav/utils/app_router.dart';
import 'package:test_scav/widgets/default_button.dart';
import 'package:test_scav/presentation/home/widgets/item_card.dart';
import 'package:test_scav/widgets/round_button.dart';

class MyItemsPage extends StatefulWidget {
  const MyItemsPage({super.key});

  @override
  State<MyItemsPage> createState() => _MyItemsPageState();
}

class _MyItemsPageState extends State<MyItemsPage> {
  late Box<ItemData> itemBox;
  

  @override
  void initState() {
    super.initState();
    itemBox = Hive.box<ItemData>(itemBoxName);
    
  }

  @override
  void dispose() {
    itemBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyItems'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          RoundButton(
            icon: Icons.add, 
            onTap: () {
                Navigator.of(context).pushNamed(AppRouter.addGroupRoute);
              }),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.44,
              ),
              
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.09,
          width: MediaQuery.of(context).size.width * 0.9,
          child: DefaultButton(
              text: "Add",
              onTap: () {
                Navigator.of(context).pushNamed(AppRouter.addItemRoute);
              }),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: itemBox.listenable(),
        builder: (context, Box<ItemData> box, widget) {
          final items = box.values.toList();

          if (items.isEmpty) {
            return const Center(child: Text('No history found'));
          } else {
            return SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                   
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ItemCard(
                            key: ValueKey(items[index].id),
                            itemId: items[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
