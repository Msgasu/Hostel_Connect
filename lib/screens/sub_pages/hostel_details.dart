import 'package:final_project/models/room_model.dart';
import 'package:final_project/screens/sub_pages/room_details.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:final_project/models/hostel_model.dart';


class HostelDetailPage extends StatelessWidget {
  final Hostel hostel;

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
                Image.network(
                  hostel.imageUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hostel.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    hostel.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRoomTypeIcon(
                        context,
                        Icons.single_bed,
                        '1 in a Room',
                        RoomDetailPage(
                          room: Room(
                            type: '1 in a Room',
                            description: 'A single room with basic amenities.',
                            imageUrls: [
                              'https://example.com/1_in_a_room_1.jpg',
                              'https://example.com/1_in_a_room_2.jpg',
                            ],
                            isFull: false,
                            occupants: ['John Doe'],
                            gender: 'male',
                          ),
                          userGender: 'male',
                        ),
                      ),
                      _buildRoomTypeIcon(
                        context,
                        Icons.hotel,
                        '2 in a Room',
                        RoomDetailPage(
                          room: Room(
                            type: '2 in a Room',
                            description: 'A room with two beds.',
                            imageUrls: [
                              'https://example.com/2_in_a_room_1.jpg',
                            ],
                            isFull: true,
                            occupants: ['Alice Johnson'],
                            gender: 'female',
                          ),
                          userGender: 'female',
                        ),
                      ),
                      _buildRoomTypeIcon(
                        context,
                        Icons.group,
                        '3 in a Room',
                        RoomDetailPage(
                          room: Room(
                            type: '3 in a Room',
                            description: 'A spacious room for three people.',
                            imageUrls: [
                              'https://example.com/3_in_a_room_1.jpg',
                            ],
                            isFull: false,
                            occupants: ['Bob Smith'],
                            gender: 'male',
                          ),
                          userGender: 'male',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Hostel Manager',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildManagerDetails(),
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
      child: Column(
        children: [
          Icon(icon, size: 40),
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildManagerDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(Icons.person, 'Name: ${hostel.managerName}'),
        SizedBox(height: 10),
        _buildDetailRow(Icons.phone, 'Contact: ${hostel.managerContact}',
            onTap: () => _launchCaller(hostel.managerContact)),
        SizedBox(height: 10),
        _buildDetailRow(Icons.email, 'Email: ${hostel.managerEmail}',
            onTap: () => _launchEmail(hostel.managerEmail)),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 40),
          SizedBox(width: 16),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  void _launchCaller(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        print('Could not launch $phoneNumber');
      }
    } catch (e) {
      print('Error launching $phoneNumber: $e');
    }
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        print('Could not launch $email');
      }
    } catch (e) {
      print('Error launching $email: $e');
    }
  }
}
