import 'package:final_project/models/room_model.dart';
import 'package:final_project/screens/sub_pages/room_details.dart';
import 'package:flutter/material.dart';


class HostelDetailPage extends StatelessWidget {
  final Map<String, String> hostel;

  HostelDetailPage({required this.hostel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  hostel['image'] ?? '', // Ensure this path is correct
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    color: Colors.black.withOpacity(0.5),
                    child: Text(
                      '3D Tour', // Placeholder text
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hostel['name'] ?? 'Hostel Name', // Ensure this value exists
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${hostel['guests']} guests'), // Example: 4 guests
                      Text('${hostel['bedrooms']} bedrooms'), // Example: 2 bedrooms
                      Text('${hostel['beds']} beds'), // Example: 2 beds
                      Text('${hostel['baths']} bath'), // Example: 1 bath
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRoomTypeIcon(
                        context,
                        Icons.single_bed,
                        '1 in a Room',
                        RoomDetailPage(room: Room(type: '1 in a room', description: '')), // Pass Room object
                      ),
                      _buildRoomTypeIcon(
                        context,
                        Icons.hotel,
                        '2 in a Room',
                        RoomDetailPage(room: Room(type: '2 in a room', description: '')), // Pass Room object
                      ),
                      _buildRoomTypeIcon(
                        context,
                        Icons.family_restroom,
                        '3 in a Room',
                        RoomDetailPage(room: Room(type: '3 in a room', description: '')), // Pass Room object
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Description placeholder...', // Example description
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$250/night',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implement booking functionality
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        ),
                        child: Text(
                          'Book Now',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
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
  }

  Widget _buildRoomTypeIcon(
      BuildContext context, IconData icon, String label, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 5, // Adjust elevation as needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Add padding around the icon
          child: Column(
            children: [
              Icon(icon, color: Colors.grey, size: 40), // Adjust icon size as needed
              SizedBox(height: 5),
              Text(label, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
