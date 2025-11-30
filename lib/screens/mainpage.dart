import 'package:flutter/material.dart';
import 'package:nursecycle/screens/article/articlepage.dart';
import 'package:nursecycle/screens/home/homepage.dart';
import 'package:nursecycle/screens/kalender/kalenderpage.dart';
import 'package:nursecycle/screens/chat/patient_chat_menu.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedIndex = 0;

  // List halaman untuk setiap menu
  static const List<Widget> _pages = <Widget>[
    Homepage(),
    Kalenderpage(),
    PatientChatMenu(),
    ArticlePage(),
    // Placeholder untuk tab Chat Pasien (Karena Chatpage butuh ID room)
    // Nanti bisa diganti dengan halaman list chat pasien
    Scaffold(body: Center(child: Text("Halaman Chat Pasien"))),
    // ArticlePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dihapus (karena Homepage punya AppBar sendiri)
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white, // Pastikan background putih

        // Gunakan elevation untuk shadow standar
        elevation: 10,

        selectedItemColor: const Color(0xFFFF6B9D),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Kalender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Article',
          ),
        ],
      ),
    );
  }
}
