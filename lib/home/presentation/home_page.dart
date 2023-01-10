import 'package:flutter/material.dart';
import 'home_page_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final tabs = <TabbarTabModel>[HomeTab(), SettingsTab()];

class _HomePageState extends State<HomePage> {
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
