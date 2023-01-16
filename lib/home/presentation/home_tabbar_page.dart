import 'package:flutter/material.dart';
import 'home_page_tab.dart';

class HomeTabbarPage extends StatefulWidget {
  const HomeTabbarPage({super.key});

  @override
  State<HomeTabbarPage> createState() => _HomeTabbarPageState();
}

final tabs = <TabbarTabModel>[HomeTab(), SettingsTab()];

class _HomeTabbarPageState extends State<HomeTabbarPage> {
  static const initialTabIndex = 0;
  final PageController controller = PageController();

  int _selectedIndex = initialTabIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        children: [
          for (final tab in tabs) tab.body,
        ],
        onPageChanged: (index) => setState(() => _selectedIndex = index),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          for (final tab in tabs)
            BottomNavigationBarItem(
              icon: Icon(tab.icon),
              label: tab.title(context),
            ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }

  void _onTap(int index) {
    if (_selectedIndex != index) {
      controller.jumpToPage(index);
    }
  }
}
