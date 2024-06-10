import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/views/activity_page.dart';
import 'package:flutter_application_uas_aktivitas/views/home_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final _pages = <Widget>[
    const HomePage(),
    const ActivityPage(),
    const Center(
      child: Icon(Icons.schedule),
    ),
  ];

  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTabIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_activity_outlined), label: 'Aktivitas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule_outlined), label: 'Jadwal Kuliah'),
        ],
        onTap: (value) => setState(() => currentTabIndex = value),
      ),
    );
  }
}
