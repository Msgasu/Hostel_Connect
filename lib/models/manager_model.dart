class HostelManager {
  final String name;
  final String contact;
  final String email;

  HostelManager({
    required this.name,
    required this.contact,
    required this.email,
  });

  // Convert to map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contact': contact,
      'email': email,
    };
  }

  // Convert from Firestore document to HostelManager object
  factory HostelManager.fromFirestore(Map<String, dynamic> data) {
    return HostelManager(
   
      contact: data['managerContact'] ?? '',
      email: data['managerEmail'] ?? '',
      name: data['managerName'] ?? '', 
    );
  }
}
