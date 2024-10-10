import 'package:flutter/material.dart';
import 'package:mycityguide/pages/BottomNav/Favorite_page.dart';
import 'package:mycityguide/pages/BottomNav/Home.dart';
import 'package:mycityguide/pages/BottomNav/Search.dart';

import '../fetching.dart';
import '../finalprofile.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({super.key});

  @override
  State<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  var pagesData = [
    const Homepage(),
    const SearchPage(),
    FavoritesPage(),
    ProfileScreen()
  ];
  int _selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: pagesData[_selectedItem],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              label: "Search", // Empty label to match the central button style
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              label: "Faivorites",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
          currentIndex: _selectedItem,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          backgroundColor: Colors.white,
          onTap: (int value) {
            setState(() {
              _selectedItem = value;
            });
          },
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
