import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final _pages = <Widget>[
    const Center(
      child: Icon(Icons.home),
    ),
    const Center(
      child: Icon(Icons.local_activity),
    ),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_activity), label: 'Aktivitas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule), label: 'Jadwal Kuliah'),
        ],
        onTap: (value) => setState(() => currentTabIndex = value),
      ),
    );
  }
}
