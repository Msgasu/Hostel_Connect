import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final int numRooms;
  final List<int> bookedRooms;
  final List<String> imageUrls;
  final String description;
  final String id;
  final String type;
  final int full;
  final int empty;

  Room({
    required this.numRooms,
    required this.bookedRooms,
    required this.imageUrls,
    required this.description,
    required this.id,
    required this.type,
    required this.full,
    required this.empty,
  });

  factory Room.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    print("Firestore Data: $data"); // Debug print

    return Room(
      numRooms: data['num_rooms'] ?? 0,
      bookedRooms: List<int>.from(data['bookedRrooms'] ?? []),
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      description: data['description'] ?? '',
      id: data['id'] ?? '',
      type: data['type'] ?? '',
      full: data['full'] ?? 0,
      empty: data['empty'] ?? 0,
    );
  }
}
