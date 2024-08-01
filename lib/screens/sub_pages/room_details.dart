import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/models/room_model.dart';
import 'package:final_project/screens/sub_pages/book_room.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class RoomDetailPage extends StatelessWidget {
  final String roomId;
  final String hostelId;

  RoomDetailPage({required this.roomId, required this.hostelId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Trigger the FutureBuilder to refresh
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => RoomDetailPage(roomId: roomId, hostelId: hostelId),
            ),
          );
        },
        child: FutureBuilder<Room>(
          future: _fetchRoom(roomId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No room data available'));
            }

            final room = snapshot.data!;
            final totalRooms = room.numRooms;
            final bookedRoomsCount = room.full; // Number of booked rooms
            final availableRooms = totalRooms - bookedRoomsCount;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageCarousel(room),
                  SizedBox(height: 20),
                  _buildRoomCount(totalRooms, availableRooms),
                  SizedBox(height: 20),
                  _buildRoomWidgets(context, room),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<Room> _fetchRoom(String roomId) async {
    final doc = await FirebaseFirestore.instance
        .collection('hostels')
        .doc(hostelId)
        .collection('room_types')
        .doc(roomId)
        .get();

    final room = Room.fromFirestore(doc);
    return room;
  }

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

  Widget _buildRoomCount(int totalRooms, int availableRooms) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'Total Rooms: $totalRooms | Available Rooms: $availableRooms',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildRoomWidgets(BuildContext context, Room room) {
    List<int> bookedRooms = room.bookedRooms.map((e) => int.tryParse(e.toString()) ?? -1).toList();

    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: room.numRooms,
        itemBuilder: (context, index) {
          int roomNumber = index + 1;
          bool isBooked = bookedRooms.contains(roomNumber);

          return GestureDetector(
            onTap: () {
              if (isBooked) {
                _showFullRoomDialog(context); // Show message if room is full
              } else {
                _showRoomBookingDialog(context, room, roomNumber);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: isBooked ? Colors.red[300] : Colors.green[300],
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                'Room $roomNumber',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFullRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Room Full'),
          content: Text('Oops, this room is currently full or already booked.'),
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

  void _showRoomBookingDialog(BuildContext context, Room room, int roomNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Booking'),
          content: Text('Do you want to book Room $roomNumber?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog

                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  print('Booking room for userId: ${user.uid}'); // Debug: print userId
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookRoomPage(
                        userId: user.uid, // Pass the current user's ID
                        hostelId: hostelId,
                        roomTypeId: roomId,
                        roomNumber: roomNumber, 
                        roomId: roomId,
                      ),
                    ),
                  );
                } else {
                  print('User is not authenticated'); // Debug: user not authenticated
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('You need to be logged in to book a room.')),
                  );
                }
              },
              child: Text('Book Now'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
