import 'package:daily_grocer/User%20Page/My_Order.dart';
import 'package:flutter/material.dart';
import 'Cart_page.dart';
import 'Home page.dart';
import 'Notification.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final List<Widget> screens = [
    HomePage(),
    CartPage(),
    MyOrderPage(),
    NotificationsPage(),
  ];

  final iconList = <IconData>[
    Icons.home_filled,
    Icons.shopping_cart,
    Icons.payment,
    Icons.notifications,
  ];

  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
