import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:final_project/models/hostel_model.dart';
import 'package:final_project/models/room_model.dart';
import 'package:final_project/screens/sub_pages/room_details.dart';

class HostelDetailPage extends StatelessWidget {
  final String hostelId;

  HostelDetailPage({required this.hostelId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('hostels').doc(hostelId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Center(child: Text('Hostel not found')),
          );
        }

        final hostel = Hostel.fromFirestore(snapshot.data!);

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
                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('hostels')
                            .doc(hostelId)
                            .collection('room_types')  // Corrected path
                            .get(),
                        builder: (context, roomSnapshot) {
                          if (roomSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (roomSnapshot.hasError) {
                            return Center(child: Text('Error: ${roomSnapshot.error}'));
                          } else if (!roomSnapshot.hasData || roomSnapshot.data!.docs.isEmpty) {
                            return Center(child: Text('No rooms found'));
                          }

                          final rooms = roomSnapshot.data!.docs;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: rooms.map((roomDoc) {
                              final room = Room.fromFirestore(roomDoc);
                              return _buildRoomTypeIcon(
                                context,
                                Icons.single_bed, // Example icon; adjust as needed
                                room.type, // Assuming 'type' or similar property exists
                                RoomDetailPage(
                                  roomId: roomDoc.id, 
                                  hostelId: hostelId,  // Pass hostelId to RoomDetailPage
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      ExpansionTile(
                        title: Text(
                          'Hostel Manager',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          _buildManagerDetails(hostel),
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

  Widget _buildManagerDetails(Hostel hostel) {
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
