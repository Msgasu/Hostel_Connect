class Room {
  final String type;
  final String description;
  final String imageUrl; 

  Room({
    required this.type,
    required this.description,
    this.imageUrl = '',
  });
}
