
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:iconsax/iconsax.dart';
import 'package:test_scav/data/models/tips/tips_data.dart';
import 'package:test_scav/presentation/history/history_page.dart';
import 'package:test_scav/presentation/home/my_items_page.dart';
import 'package:test_scav/presentation/home/test/my_items_page_copy.dart';
import 'package:test_scav/presentation/home/test/test_my_items.dart';
import 'package:test_scav/presentation/settings/settings_copy.dart';
import 'package:test_scav/presentation/tips/tip_display.dart';
import 'package:test_scav/presentation/settings/settings.dart';
import 'package:test_scav/utils/assets.dart';



class NavigationPage extends StatefulWidget {
  final Root rootData;
  final String appDocumentsDirPath;
  const NavigationPage({super.key, required this.rootData, required this.appDocumentsDirPath});

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
          height: MediaQuery.of(context).size.height * 0.1,
          indicatorColor: Colors.transparent,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white, fontSize: 0),
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
                
                icon: SvgPicture.asset(selectedIndex == 0 ? SvgAssets.homeFilled : SvgAssets.homeLight), label: '',
              ),
              NavigationDestination(
                icon: SvgPicture.asset(selectedIndex == 1 ? SvgAssets.timeCircleFilled : SvgAssets.timeCircleLight), label: '',
              ),
              NavigationDestination(
                icon: SvgPicture.asset(selectedIndex == 2 ? SvgAssets.documentFilled : SvgAssets.documentLight), label: '', 
              ),
              NavigationDestination(
              icon: SvgPicture.asset(selectedIndex == 3 ? SvgAssets.settingsFilled : SvgAssets.settingsLight), label: '',
  
              ),
       
          
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          MyItemsPage(appDocumentsDirPath: widget.appDocumentsDirPath),
          const HistoryPage(),
          TipDisplay(rootData: widget.rootData),
          const Settings(),
        ],
      ),
    );
  }
}
