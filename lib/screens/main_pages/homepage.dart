import 'package:flutter/material.dart';
import 'package:final_project/widgets/custom_navigation_bar.dart';
import 'package:final_project/screens/sub_pages/hostel_details.dart';
import 'package:final_project/screens/main_pages/wishlist.dart';
import 'package:final_project/screens/sub_pages/profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Map<String, String>> hostels = [
    {
      'name': 'Old Hosanna',
      'image': 'assets/old_hosanna.jpg',
      'price': '5500-6000',
      'room': '2 in a room and 3 in a room',
    },
    {
      'name': 'Colombiana',
      'image': 'assets/colombiana.jpg',
      'price': '5000-6000',
      'room': '1 in a room and 2 in a room',
    },
    {
      'name': 'Charlotte Courts',
      'image': 'assets/charlotte_courts.jpg',
      'price': '5000-6000',
      'room': '1 in a room and 2 in a room',
    },
    {
      'name': 'Old Masere',
      'image': 'assets/old_masere.jpg',
      'price': '5000-6000',
      'room': '1 in a room, 2 in a room and 3 in a room',
    },
    {
      'name': 'Dufie Platinum',
      'image': 'assets/Dufie_Platinum.jpg',
      'price': '5000-6000',
      'room': '1 in a room, 2 in a room and 3 in a room',
    },
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Top Section
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/welcome.jpg', // Replace with your top background image
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
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
          // Hostels List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HostelDetailPage(
                          hostel: hostels[index],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0),
                          ),
                          child: _buildImage(hostels[index]['image']!),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    hostels[index]['name']!,
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                hostels[index]['price']!,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 5),
                                  Text(
                                    hostels[index]['room']!,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(width: 5),
                                ],
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
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    return Image.asset(
      imagePath,
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
