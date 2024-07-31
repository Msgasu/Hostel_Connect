import 'package:final_project/models/room_model.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomDetailPage extends StatelessWidget {
  final String roomId;
  final String hostelId;

  RoomDetailPage({required this.roomId, required this.hostelId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Room>(
      future: _fetchRoom(roomId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Room Details'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Room Details'),
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Room Details'),
            ),
            body: Center(child: Text('No room data available')),
          );
        }

        final room = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(room.type),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageCarousel(room),
                SizedBox(height: 20),
                _buildRoomCount(room),
                SizedBox(height: 20),
                _buildRoomWidgets(context, room),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Room> _fetchRoom(String roomId) async {
    final doc = await FirebaseFirestore.instance
        .collection('hostels')
        .doc(hostelId) // Replace with actual hostel ID
        .collection('room_types')
        .doc(roomId)
        .get();

    return Room.fromFirestore(doc);
  }


// control carousel
  Widget _buildImageCarousel(Room room) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1.0,
      ),
      items: room.imageUrls.map((imageUrl) {
        return Builder(
          builder: (BuildContext context) {
            return Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildRoomCount(Room room) {
    int totalRooms = room.numRooms;
    int availableRooms = room.empty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'Total Rooms: $totalRooms | Available Rooms: $availableRooms',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildRoomWidgets(BuildContext context, Room room) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: room.numRooms,
        itemBuilder: (context, index) {
          bool isFull = room.full > 0;
          return GestureDetector(
            onTap: () {
              _showRoomDetails(context, room);
            },
            child: Container(
              decoration: BoxDecoration(
                color: isFull ? Colors.red[300] : Colors.green[300],
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                'Room ${index + 1}', // Example room number
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showRoomDetails(BuildContext context, Room room) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Room Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status: ${room.full > 0 ? 'Full' : 'Available'}'),
              SizedBox(height: 10),
              Text(
                  'Occupants: ${room.empty}'), // Modify based on actual occupant data if available
              SizedBox(height: 10),
              Text('Description: ${room.description}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
