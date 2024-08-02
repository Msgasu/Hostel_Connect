import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/screens/main_pages/booked_rooms.dart';
import 'package:final_project/screens/main_pages/homepage.dart';
import 'package:final_project/screens/sub_pages/hostel_details.dart';
import 'package:final_project/screens/sub_pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:final_project/widgets/custom_navigation_bar.dart'; // Import Custom Navigation Bar

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  int _currentIndex = 1; // Set the index for WishlistPage

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Remove the leading property to get rid of the back button
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: user != null
            ? FirebaseFirestore.instance
                .collection('wishlists')
                .doc(user.uid)
                .collection('items')
                .snapshots()
            : Stream.empty(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No items in wishlist'));
          }

          final wishlistItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: wishlistItems.length,
            itemBuilder: (context, index) {
              final item = wishlistItems[index];
              final name = item['name'];
              final imageUrl = item['imageUrl'];
              final hostelId = item.id;

              return ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  name,
                  style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeFromWishlist(context, hostelId),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HostelDetailPage(hostelId: hostelId)),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  void _removeFromWishlist(BuildContext context, String hostelId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('wishlists')
            .doc(user.uid)
            .collection('items')
            .doc(hostelId)
            .delete();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Removed from Wishlist')));
      } catch (e) {
        print('Error removing from wishlist: $e');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to remove from Wishlist')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You need to be logged in to remove from Wishlist')));
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Navigate to the corresponding page based on the selected index
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WishlistPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BookedRoomsPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }
}
