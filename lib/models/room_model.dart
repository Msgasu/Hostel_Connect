import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String description;
  final int empty;
  final int full;
  final String id;
  final List<String> imageUrls;
  final int numRooms;
  final String type;

  Room({
    required this.description,
    required this.empty,
    required this.full,
    required this.id,
    required this.imageUrls,
    required this.numRooms,
    required this.type,
  });

  // Factory constructor to create a Room instance from a Firestore document
  factory Room.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Room(
      description: data['description'] ?? '',
      empty: (data['empty'] as int?) ?? 0,
      full: (data['full'] as int?) ?? 0,
      id: data['id'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      numRooms: (data['num_rooms'] as int?) ?? 0,
      type: data['type'] ?? '',
    );
  }
}
