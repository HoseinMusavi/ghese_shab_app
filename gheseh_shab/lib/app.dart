import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/data/repositories/story_repository.dart';
import 'package:gheseh_shab/logic/story_bloc/story_bloc.dart';
import 'package:gheseh_shab/presentation/screens/home_page.dart';
import 'package:gheseh_shab/presentation/screens/login/login_screen.dart';

class GhesehShabApp extends StatefulWidget {
  final Function(ThemeMode) setThemeMode;

  const GhesehShabApp({Key? key, required this.setThemeMode}) : super(key: key);

  @override
  _GhesehShabAppState createState() => _GhesehShabAppState();
}

class _GhesehShabAppState extends State<GhesehShabApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),

    const Center(child: Text('Home Page', style: TextStyle(fontSize: 18))),

    const Center(child: Text('Favorites Page', style: TextStyle(fontSize: 18))),
    LoginScreen(), // صفحه ورود به حساب کاربری
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: _pages[_currentIndex], // نمایش صفحه فعلی
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // تغییر صفحه بر اساس انتخاب کاربر
          });
        },
        backgroundColor: isDarkMode
            ? const Color(0xFF0E2A3A) // رنگ پس‌زمینه در حالت دارک مود
            : Colors.white, // رنگ پس‌زمینه در حالت لایت مود
        selectedItemColor: isDarkMode
            ? Colors.blueAccent // رنگ آیتم انتخاب‌شده در حالت دارک مود
            : Colors.deepPurple, // رنگ آیتم انتخاب‌شده در حالت لایت مود
        unselectedItemColor: isDarkMode
            ? Colors.white70 // رنگ آیتم‌های غیرفعال در حالت دارک مود
            : Colors.grey, // رنگ آیتم‌های غیرفعال در حالت لایت مود
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'خانه',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'جستجو',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'پسندها',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'حساب',
          ),
        ],
      ),
    );
  }
}
