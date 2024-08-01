import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/screens/main_pages/booked_rooms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_project/providers/hostel_provider.dart';
import 'package:final_project/screens/sub_pages/hostel_details.dart';
import 'package:final_project/screens/main_pages/wishlist.dart';
import 'package:final_project/screens/sub_pages/profile.dart';
import 'package:final_project/widgets/custom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch hostels when the widget is initialized
    Future.microtask(() {
      Provider.of<HostelProvider>(context, listen: false).fetchHostels();
    });
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
    case 3: // New case for Booked Rooms
      Navigator.pushReplacement(
        context,  
        MaterialPageRoute(builder: (context) => ProfilePage()),
       // Ensure you have BookedRoomsPage
      );
      break;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Positioned.fill(
          //   // child: Image.asset(
          //   //   // 'assets/home_back.jpg', // Replace with your background image asset
          //   //   fit: BoxFit.cover,
          //   // ),
          // ),
          Consumer<HostelProvider>(
            builder: (context, provider, child) {
              final hostels = provider.hostels;

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/welcome.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to Hostel Finder!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Find the best hostels near you.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final hostel = hostels[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HostelDetailPage(
                                  hostelId: hostel.id, // Ensure Hostel has an id
                                ),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            elevation: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                  child: _buildImage(hostel.imageUrl),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hostel.name,
                                        style: TextStyle(
                                            fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        hostel.description,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: hostels.length,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return imageUrl.isNotEmpty
        ? Image.network(
            imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        : Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey,
            child: Center(
              child: Text(
                'No Image',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
  }
}
