

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/models/history_data.dart';
import 'package:test_scav/widgets/history_card.dart'; 


class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Box<HistoryData> placeBox;

  @override
  void initState() {
    super.initState();
    placeBox = Hive.box<HistoryData>(historyBoxName);
  }

  @override
  void dispose() {
    placeBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: ValueListenableBuilder(
        valueListenable: placeBox.listenable(),
        builder: (context, Box<HistoryData> box, widget) {
          final places = box.values.toList();

          if (places.isEmpty) {
            return const Center(child: Text('No history found'));
          } else {
            return ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                final placeData = places[index];

                return HistoryCard(
                        key: ValueKey(places[index].id), // Unique key
                        item: places[index],
                      );
              },
            );
          }
        },
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:test_scav/main.dart';
// import 'package:test_scav/models/history_data.dart';
// import 'package:test_scav/utils/app_router.dart';
// import 'package:test_scav/widgets/default_button.dart';
// import 'package:test_scav/widgets/history_card.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';


// class HistoryPage extends StatefulWidget {
//   const HistoryPage({super.key});

//   @override
//   State<HistoryPage> createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage> {
//   List<HistoryData> items = [];
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
//       final box = await Hive.openBox<HistoryData>(historyBoxName);
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
//         appBar: AppBar(title: const Text('History')),
        
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
//                                       child: HistoryCard(
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

