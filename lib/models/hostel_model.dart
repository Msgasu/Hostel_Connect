import 'package:cloud_firestore/cloud_firestore.dart';

class Hostel {
  final String id; // Unique identifier for the hostel
  final String name; // Name of the hostel
  final String imageUrl; // URL of the hostel's image
  final String price; // Price information with the Cedi symbol
  final String description; // Description of the hostel
  final String managerName; // Name of the hostel manager
  final String managerContact; // Contact number of the hostel manager
  final String managerEmail; // Email address of the hostel manager
  final String location; // Location of the hostel
  final String priceRange; // Price range for the hostel

  Hostel({
    required this.id, // Include id in the constructor
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.managerName,
    required this.managerContact,
    required this.managerEmail,
    required this.location,
    required this.priceRange,
  });

  // Convert Firestore document to Hostel object
  factory Hostel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Hostel(
      id: doc.id, // Assign the document ID to the id field
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: data['price'] ?? '', // Ensure 'price' is properly formatted in Firestore
      description: data['description'] ?? '',
      managerName: data['managerName'] ?? '',
      managerContact: data['managerContact'] ?? '',
      managerEmail: data['managerEmail'] ?? '',
      location: data['locationUrl'] ?? '', // Add location field
      priceRange: data['priceRange'] ?? '', // Add priceRange field
    );
  }

  // Convert Hostel object to map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'price': price, // Store price information as string with currency symbol
      'description': description,
      'managerName': managerName,
      'managerContact': managerContact,
      'managerEmail': managerEmail,
      'locationUrl': location, // Store location
      'priceRange': priceRange, // Store price range
    };
  }
}
