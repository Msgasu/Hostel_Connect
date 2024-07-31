// room_detail_page.dart

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:final_project/models/room_model.dart';

// Hardcoded room data
List<Room> rooms = [
  Room(
    type: 'Single Room',
    description: 'A single room with a bed and basic amenities.',
    imageUrls: ['https://example.com/room1.jpg', 'https://example.com/room2.jpg'],
    isFull: false,
    occupants: ['John Doe'],
    gender: 'male',
  ),
  Room(
    type: 'Double Room',
    description: 'A room with two beds for sharing.',
    imageUrls: ['https://example.com/room3.jpg'],
    isFull: true,
    occupants: ['Alice Johnson'],
    gender: 'female',
  ),
  // Add more rooms as needed
];

class RoomDetailPage extends StatelessWidget {
  final Room room;
  final String userGender; // User's gender for booking

  RoomDetailPage({required this.room, required this.userGender});

  @override
  Widget build(BuildContext context) {
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
            _buildImageCarousel(),
            SizedBox(height: 20),
            _buildRoomCount(),
            SizedBox(height: 20),
            _buildRoomWidgets(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
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

  Widget _buildRoomCount() {
    int totalRooms = rooms.length;
    int availableRooms = rooms.where((r) => !r.isFull && r.gender == userGender).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'Total Rooms: $totalRooms | Available Rooms: $availableRooms',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildRoomWidgets(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          // Filter rooms based on gender and availability
          if (room.gender != userGender) {
            return SizedBox.shrink(); // Skip if room gender does not match user
          }
          return GestureDetector(
            onTap: () {
              _showRoomDetails(context, room);
            },
            child: Container(
              decoration: BoxDecoration(
                color: room.isFull ? Colors.red[300] : Colors.green[300],
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
              Text('Status: ${room.isFull ? 'Full' : 'Available'}'),
              SizedBox(height: 10),
              Text('Occupants: ${room.occupants.join(', ')}'),
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
