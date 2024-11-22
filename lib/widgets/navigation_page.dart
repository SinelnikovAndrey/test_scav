
import 'package:flutter/material.dart';
import 'package:test_scav/data/models/tips/tips_data.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/presentation/history/history_page.dart';
import 'package:test_scav/presentation/home/my_items_page.dart';
import 'package:test_scav/presentation/notification/reminder_list.dart';
import 'package:test_scav/presentation/tips/tip_display.dart';
import '../presentation/notification/reminder/reminder.dart';






class NavigationPage extends StatefulWidget {
  final Root rootData;
  const NavigationPage({super.key, required this.rootData});

  @override
  State<NavigationPage> createState() => _HomePageState();
}

class _HomePageState extends State<NavigationPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x7FE6EAF3),
              blurRadius: 37,
              offset: Offset(0, -12),
              spreadRadius: 0,
            )
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.list),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(Icons.tips_and_updates),
              label: 'Tip',
            ),
            NavigationDestination(
              icon: Icon(Icons.text_format_sharp),
              label: 'Test',
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          const MyItemsPage(),
          const HistoryPage(),
          TipDisplay(rootData: widget.rootData),
          const ReminderList(),
        ],
      ),
    );
  }
}
