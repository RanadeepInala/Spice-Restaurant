import 'package:flutter/material.dart';
import 'package:food_delivery/favourite/favourite_screen.dart';
import 'package:food_delivery/home/home_screen.dart';
import 'package:food_delivery/home/new_category_screen.dart';
import 'package:food_delivery/profile/profile_screen.dart';
import 'package:food_delivery/setting/setting_screen.dart';

import '../components/colors.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, Widget>> pages = [
    {
      'page': NewCategoryScreen(),
    },
    {
      'page': FavouriteScreen(),
    },
    {
      'page': SettingScreen(),
    },
    {
      'page': ProfileScreen(),
    },
  ];
  int selectedPageIndex = 0;

  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Latest News'),
      // ),
      body: pages[selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
        backgroundColor: secondColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        currentIndex: selectedPageIndex,

        items: [
          BottomNavigationBarItem(
            backgroundColor: secondColor,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: secondColor,
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            backgroundColor: secondColor,
            icon: Icon(Icons.shopping_bag),
            label: 'My Orders',
          ),
          BottomNavigationBarItem(
            backgroundColor: secondColor,
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}