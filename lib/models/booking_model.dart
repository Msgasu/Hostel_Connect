import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String userId;
  final String hostelId;
  final String roomTypeId;
  final int roomNumber;
  final Timestamp timestamp;

  Booking({
    required this.userId,
    required this.hostelId,
    required this.roomTypeId,
    required this.roomNumber,
    required this.timestamp,
  });

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Booking(
      userId: data['userId'],
      hostelId: data['hostelId'],
      roomTypeId: data['roomTypeId'],
      roomNumber: data['roomNumber'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'hostelId': hostelId,
      'roomTypeId': roomTypeId,
      'roomNumber': roomNumber,
      'timestamp': timestamp,
    };
  }
}
