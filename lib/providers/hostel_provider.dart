// lib/providers/hostel_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:final_project/models/hostel_model.dart';

class HostelProvider with ChangeNotifier {
  List<Hostel> _hostels = [];

  List<Hostel> get hostels => _hostels;

  Future<void> fetchHostels() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('hostels').get();
      _hostels = snapshot.docs.map((doc) => Hostel.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching hostels: $e');
    }
  }
}
