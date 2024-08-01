import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> bookRoom(String hostelId, String roomId, int roomNumber) async {
    final roomRef = _firestore
        .collection('hostels')
        .doc(hostelId)
        .collection('room_types')
        .doc(roomId);

    try {
      await _firestore.runTransaction((transaction) async {
        final roomDoc = await transaction.get(roomRef);
        if (!roomDoc.exists) {
          throw Exception('Room document does not exist');
        }

        final roomData = roomDoc.data()!;
        final bookedRooms = List<dynamic>.from(roomData['bookedRooms'] ?? []);
        final totalRooms = (roomData['numRooms'] as int?) ?? 0;
        final bookedRoomsCount = (roomData['full'] as int?) ?? 0;
        final availableRooms = totalRooms - bookedRoomsCount;

        // Check if the room is already booked
        if (bookedRooms.contains(roomNumber)) {
          throw Exception('Room is already booked');
        }

        // Check if there are available rooms before booking
        if (availableRooms <= 0) {
          throw Exception('No available rooms to book');
        }

        // Update bookedRooms and room counts
        bookedRooms.add(roomNumber);
        transaction.update(roomRef, {
          'bookedRooms': bookedRooms,
          'full': bookedRoomsCount + 1,
          'empty': availableRooms - 1,
        });
      });
    } catch (e) {
      print('Error during transaction: $e');
      // Optionally throw the error to be handled by the caller
      rethrow;
    }
  }
}
