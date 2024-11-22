
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:test_scav/data/models/tips/tips_data.dart';
import 'package:test_scav/presentation/history/history_page.dart';
import 'package:test_scav/presentation/home/my_items_page.dart';
import 'package:test_scav/presentation/tips/tip_display.dart';
import 'package:test_scav/presentation/settings/settings.dart';



class NavigationPage extends StatefulWidget {
  final Root rootData;
  const NavigationPage({super.key, required this.rootData});

  @override
  State<NavigationPage> createState() => _HomePageState();
}

class _HomePageState extends State<NavigationPage> {
    int selectedIndex = 0;
  final Color backgroundColor = Colors.black87; 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: 
      
      NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white),
          ),
        ),
        child: Container(
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
            
            backgroundColor: backgroundColor, 
            indicatorColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: Icon(selectedIndex == 0 ? Icons.home_filled : Icons.home_outlined,
                color: Colors.white,
                ), 
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(selectedIndex == 1 ? Iconsax.clock5 : Iconsax.clock,
                color: Colors.white,
                ), 
                label: 'History',
              ),
              NavigationDestination(
                icon: Icon(selectedIndex == 2 ? Iconsax.document : Iconsax.document_text4,
                color: Colors.white,
                ),
                label: 'Tip', 
              ),
              NavigationDestination(
                icon: Icon(selectedIndex == 3 ? Icons.settings : Iconsax.setting_2,
                color: Colors.white,
                ),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          const MyItemsPage(),
          const HistoryPage(),
          TipDisplay(rootData: widget.rootData),
          const Settings(),
        ],
      ),
    );
  }
}
