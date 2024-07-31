// room_model.dart

class Room {
  final String type;
  final String description;
  final List<String> imageUrls;
  final bool isFull;
  final List<String> occupants;
  final String gender;

  Room({
    required this.type,
    required this.description,
    required this.imageUrls,
    required this.isFull,
    required this.occupants,
    required this.gender,
  });
}
