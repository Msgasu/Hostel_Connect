import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  CustomBottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, -2), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 28),
              label: 'Home',
              backgroundColor: Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, size: 28),
              label: 'Wishlist',
              backgroundColor: Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 28),
              label: 'Profile',
              backgroundColor: Colors.transparent,
            ),
          ],
          selectedItemColor: Color.fromARGB(255, 172, 73, 33),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
