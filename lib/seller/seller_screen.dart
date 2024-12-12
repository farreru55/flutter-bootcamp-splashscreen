import 'package:flutter/material.dart';
import 'package:flutter_application_1/seller/category/index_screen.dart';
import 'package:flutter_application_1/seller/product/index_screen.dart';
import 'package:flutter_application_1/seller/profile/index_screen.dart';

class SellerScreen extends StatefulWidget{
  const SellerScreen({super.key});

  @override
  _SellerScreenState createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen>{
  int _currentIndex = 0;

  final List<Widget> _screens = [
    IndexProductScreen(),
    const IndexCategoryScreen(),
    const IndexProfileScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}