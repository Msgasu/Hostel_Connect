import 'package:cloud_firestore/cloud_firestore.dart';

class Hostel {
  final String name;
  final String imageUrl;
  final String price;
  final String description;
  final String managerName;
  final String managerContact;
  final String managerEmail;
  

  Hostel({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.managerName,
    required this.managerContact,
    required this.managerEmail,
  });

  // Convert Firestore document to Hostel object
  factory Hostel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Hostel(
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: data['price'] ?? '',
      description: data['description'] ?? '',
      managerName: data['managerName'] ?? '',
      managerContact: data['managerContact'] ?? '',
      managerEmail: data['managerEmail'] ?? '',
    );
  }

  // Convert Hostel object to map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'description': description,
      'managerName': managerName,
      'managerContact': managerContact,
      'managerEmail': managerEmail,
    };
  }
}
