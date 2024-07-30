import 'package:final_project/models/room_model.dart';
import 'package:flutter/material.dart';


class RoomDetailPage extends StatelessWidget {
  final Room room;

  RoomDetailPage({required this.room});

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
            Text(
              room.type,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Detailed description of the room type here.',
              style: TextStyle(color: Colors.grey),
            ),
            // Add more details here
          ],
        ),
      ),
    );
  }
}
