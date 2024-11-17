import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/models/item_data.dart';
import 'package:test_scav/utils/app_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:test_scav/widgets/item_card.dart';

class TestMyItemsPage extends StatefulWidget {
  const TestMyItemsPage({Key? key}) : super(key: key);

  @override
  State<TestMyItemsPage> createState() => _TestMyItemsPageState();
}

class _TestMyItemsPageState extends State<TestMyItemsPage> {
  List<ItemData> items = [];
  List<ItemData> displayedItems = []; 
  List<String> uniqueGroups = []; 
  String? selectedGroup; 
  bool isLoading = false;
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
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

  void _updateUniqueGroups() {
    final groupSet = items.map((e) => e.group).toSet();
    uniqueGroups = groupSet.toList()..sort();
    uniqueGroups.insert(0, 'All'); 
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

  void _filterItems(String? group) {
    setState(() {
      selectedGroup = group;
      displayedItems = group == 'All'
          ? items
          : items.where((item) => item.group == group).toList();
    });
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: selectedGroup,
                decoration: const InputDecoration(labelText: 'Filter by Group'),
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
                      : ListView.builder(
                          itemCount: displayedItems.length,
                          itemBuilder: (context, index) {
                            return ItemCard(
                              key: ValueKey(displayedItems[index].id),
                              item: displayedItems[index],
                            );
                          },
                        ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.addItemRoute);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}