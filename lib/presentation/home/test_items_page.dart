import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:test_scav/widgets/default_button.dart';
import 'package:test_scav/widgets/item_card.dart';

class TestMyItemsPage extends StatefulWidget {
  const TestMyItemsPage({Key? key}) : super(key: key);

  @override
  State<TestMyItemsPage> createState() => _TestMyItemsPageState();
}

class _TestMyItemsPageState extends State<TestMyItemsPage> {
  List<ItemData> items = [];
  bool isLoading = false;
  final RefreshController _refreshController = RefreshController();

  List<ItemData> displayedItems = [];
  List<String> uniqueGroups = [];
  String? selectedGroup;

  late Box<ItemData> itemBox;

  @override
  void initState() {
    super.initState();
    _loadItems();
    itemBox = Hive.box<ItemData>(itemBoxName);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _updateUniqueGroups() {
    final groupSet = items.map((e) => e.group).toSet();
    uniqueGroups = groupSet.toList()..sort();
    uniqueGroups.insert(0, 'All');
  }

  void _filterItems(String? group) {
    setState(() {
      selectedGroup = group;
      displayedItems = group == 'All'
          ? items
          : items.where((item) => item.group == group).toList();
    });
  }

  Future<void> _loadItems() async {
    setState(() {
      isLoading = true;
    });
    try {
      final box = await Hive.openBox<ItemData>(itemBoxName);
      items = box.values.toList();
      _updateUniqueGroups();
      displayedItems = items;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error loading items: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    try {
      await _loadItems(); 
      await Future.delayed(const Duration(seconds: 1));
      _refreshController.refreshCompleted();
    } catch (error) {
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      header: const WaterDropHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: Scaffold(
        appBar: AppBar(title: const Text('My Items')),
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
          final places = box.values.toList();

            if (places.isEmpty) {
              return const Center(child: Text('No history found'));
            } else {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                          color: AppColors.gray,
                          style: BorderStyle.solid,
                          width: 1),
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      value: selectedGroup,
                      items: uniqueGroups.map((group) {
                        return DropdownMenuItem<String>(
                          value: group,
                          child: Text(group),
                        );
                      }).toList(),
                      onChanged: _filterItems,
                    ),
                  ),
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : displayedItems.isEmpty
                            ? const Center(child: Text('No items found'))
                            : 
                            ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {

                return ItemCard(
                        key: ValueKey(places[index].id),
                        itemId: places[index],
                      );
              },
            ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

