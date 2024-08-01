import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:final_project/models/hostel_model.dart';
import 'package:final_project/models/room_model.dart';
import 'package:final_project/screens/sub_pages/room_details.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart'; // Import phone caller package
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package

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
                        style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        hostel.description,
                        style: GoogleFonts.lato(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('hostels')
                            .doc(hostelId)
                            .collection('room_types')
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
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: RoomTypeIcons(
                              rooms: rooms,
                              hostelId: hostelId,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      ExpansionTile(
                        title: Text(
                          'Hostel Manager',
                          style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
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
          Icon(icon, size: 40, color: Color.fromARGB(255, 172, 73, 33)), // Icon color
          SizedBox(width: 16),
          Expanded(child: Text(text, style: GoogleFonts.lato(fontSize: 16))),
        ],
      ),
    );
  }

  void _launchCaller(String phoneNumber) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    } catch (e) {
      print('Error launching phone call: $e');
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

class RoomTypeIcons extends StatelessWidget {
  final List<QueryDocumentSnapshot> rooms;
  final String hostelId;

  RoomTypeIcons({
    required this.rooms,
    required this.hostelId,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16.0, // Horizontal spacing between icons
      runSpacing: 16.0, // Vertical spacing between rows
      children: rooms.map((roomDoc) {
        final room = Room.fromFirestore(roomDoc);
        return RoomTypeIcon(
          icon: Icons.single_bed, // Example icon; adjust as needed
          label: room.type, // Assuming 'type' or similar property exists
          page: RoomDetailPage(
            roomId: roomDoc.id, 
            hostelId: hostelId,  // Pass hostelId to RoomDetailPage
          ),
        );
      }).toList(),
    );
  }
}

class RoomTypeIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget page;

  RoomTypeIcon({
    required this.icon,
    required this.label,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Column(
        children: [
          Icon(icon, size: 40, color: Color.fromARGB(255, 172, 73, 33)), // Icon color
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.lato(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
