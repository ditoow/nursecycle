import 'package:flutter/material.dart';
import 'package:nursecycle/core/colorconfig.dart'; // Pastikan primaryColor ada
import 'package:nursecycle/screens/admin/access_stats_page.dart';
import 'package:nursecycle/screens/home/nurse_homepage.dart';
import 'package:nursecycle/screens/chat/chatqueuepage.dart';
import 'package:nursecycle/screens/article/manage_articles_page.dart';

class NurseMainPage extends StatefulWidget {
  const NurseMainPage({super.key});

  @override
  State<NurseMainPage> createState() => _NurseMainPageState();
}

class _NurseMainPageState extends State<NurseMainPage> {
  int _selectedIndex = 0;

  // Daftar Halaman untuk Admin/Perawat
  static const List<Widget> _pages = <Widget>[
    NurseHomePage(), // Index 0: Dashboard
    ChatQueuePage(), // Index 1: Antrian Chat (Full Page)
    ManageArticlesPage(), // Index 2: Kelola Artikel
    AccessStatsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body menampilkan halaman sesuai tab yang dipilih
      body: _pages[_selectedIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor, // Warna pink/utama
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Antrian',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_document),
              activeIcon: Icon(Icons.description),
              label: 'Artikel',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              activeIcon: Icon(Icons.analytics_rounded),
              label: 'Statistik',
            ),
          ],
        ),
      ),
    );
  }
}
