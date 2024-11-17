import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/models/item_data.dart';
import 'package:test_scav/utils/app_router.dart';
import 'package:test_scav/widgets/default_button.dart';
import 'package:test_scav/widgets/item_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyItemsPage extends StatefulWidget {
  const MyItemsPage({Key? key}) : super(key: key);

  @override
  State<MyItemsPage> createState() => _MyItemsPageState();
}

class _MyItemsPageState extends State<MyItemsPage> {
  List<ItemData> items = [];
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
      await _loadItems(); // Correctly call _loadItems
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
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : items.isEmpty
                ? const Center(
                    child: Text('No items found')) // Handle empty state
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ItemCard(
                        key: ValueKey(items[index].id), // Unique key
                        item: items[index],
                      );
                    },
                  ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:test_scav/main.dart';
// import 'package:test_scav/models/item_data.dart';
// import 'package:test_scav/utils/app_router.dart';
// import 'package:test_scav/widgets/default_button.dart';
// import 'package:test_scav/widgets/item_card.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';


// class MyItemsPage extends StatefulWidget {
//   const MyItemsPage({Key? key}) : super(key: key);

//   @override
//   State<MyItemsPage> createState() => _MyItemsPageState();
// }

// class _MyItemsPageState extends State<MyItemsPage> {
//   List<ItemData> items = [];
//   bool isLoading = false;
//   final RefreshController _refreshController = RefreshController();


//   @override
//   void initState() {
//     super.initState();
//     _loadItems();
//   }

//    @override
//   void dispose() {
//     _refreshController.dispose(); 
//     super.dispose();
    
//   }


//   Future<void> _loadItems() async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       final box = await Hive.openBox<ItemData>(itemBoxName);
//       items = box.values.toList();
//     } catch (e) {
//       // Handle error
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading items: $e')));
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }


//   Future<void> _onRefresh() async {
//     try {
//       _loadItems;
//       await Future.delayed(const Duration(seconds: 1));

//       _refreshController.refreshCompleted();
//     } catch (error) {
//       _refreshController.refreshFailed();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SmartRefresher(
//         enablePullDown: true,
//         header: WaterDropHeader(),
//         controller: _refreshController,
//         onRefresh: _onRefresh, 
//       child: Scaffold(
//         appBar: AppBar(title: const Text('My Items')),
//         bottomNavigationBar: DefaultButton(
//               text: "Add",
//               onTap: () {
//                 Navigator.of(context).pushNamed(AppRouter.addItemRoute);
//               }),
//         body: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : SingleChildScrollView(
//               child: GestureDetector(
//                     onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//                     child: Column(
//                       children: [
//                         // best selling
//                         if (items.isNotEmpty) ...[
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height,
//                             width: MediaQuery.of(context).size.width,
//                             child: 
//                             ListView.builder(
//                               scrollDirection: Axis.vertical,
//                               // padding: const EdgeInsets.symmetric(horizontal: 25),
//                               itemCount: items.length,
//                               itemBuilder: (context, index) {
//                                 return Row(
                                  
//                                   children: [
//                                     Flexible(
//                                       child: ItemCard(
//                                         item: items[index],
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//             ),
      
      
//       ),
//     );
//   }
// }

