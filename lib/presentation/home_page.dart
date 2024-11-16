
import 'package:flutter/material.dart';
import 'package:test_scav/presentation/my_items_page.dart';
// import 'package:flutter_svg/svg.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              icon: Icon(Icons.home),
              label: 'History',
            ),
       
           
          ],
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: const [
         MyItemsPage(),
         MyItemsPage(),
          // HistoryPage(),
         
        ],
      ),
    );
  }
}
