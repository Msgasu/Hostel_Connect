import 'package:final_project/screens/main_pages/homepage.dart';
import 'package:final_project/screens/sub_pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:final_project/widgets/custom_navigation_bar.dart'; // Adjust the import path as needed

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  int _currentIndex = 1; // Ensure WishlistPage is selected

  final List<Map<String, String>> wishlistItems = [
    {'name': 'Old Hosanna', 'image': 'assets/old_hosanna.jpg'},
    {'name': 'Colombiana', 'image': 'assets/colombiana.jpg'},
    // Add more items as needed
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        switch (index) {
          case 0:
            return HomePage();
          case 1:
            return WishlistPage();
          case 2:
            return ProfilePage();
          default:
            return HomePage();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
        backgroundColor: Color.fromARGB(255, 114, 23, 23), // Wine color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: wishlistItems.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      wishlistItems[index]['image']!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    wishlistItems[index]['name']!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
