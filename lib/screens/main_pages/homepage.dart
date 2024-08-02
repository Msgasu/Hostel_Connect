import 'package:final_project/services/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_project/providers/hostel_provider.dart';
import 'package:final_project/screens/sub_pages/hostel_details.dart';
import 'package:final_project/screens/main_pages/wishlist.dart';
import 'package:final_project/screens/main_pages/booked_rooms.dart';
import 'package:final_project/screens/sub_pages/profile.dart';
import 'package:final_project/widgets/custom_navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<HostelProvider>(context, listen: false).fetchHostels();
    });
  }

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

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HostelProvider>(
        builder: (context, provider, child) {
          final hostels = provider.hostels;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200, // Adjusted height for the image
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      '',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  background: Image.asset(
                    'assets/splash.jpg', // Replace with your asset path
                    fit: BoxFit.cover,
                  ),
                ),
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
                              hostelId: hostel.id,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        elevation: 10,
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
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hostel.name,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Price Range: ${hostel.priceRange}',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black54),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        'Location:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      IconButton(
                                        icon: Icon(Icons.location_on,
                                            color: Colors.blueAccent),
                                        onPressed: () =>
                                            _launchURL(hostel.location),
                                        padding: EdgeInsets.zero,
                                      ),
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
          );
        },
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
