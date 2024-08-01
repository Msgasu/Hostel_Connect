import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingNotifier extends ChangeNotifier {
  bool isLoading = false;
  String? hostelName;
  String? roomType;
  String? description;
  int? numRooms;
  List<String>? imageUrls;
  List<int>? bookedRooms;
  String errorMessage = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch hostel details from Firestore
  Future<void> fetchHostelDetails(String hostelId, String roomTypeId) async {
    isLoading = true;
    notifyListeners();

    try {
      DocumentSnapshot hostelSnapshot = await _firestore.collection('hostels').doc(hostelId).get();

      if (hostelSnapshot.exists) {
        hostelName = hostelSnapshot['name'];
        description = hostelSnapshot['description'];
        numRooms = hostelSnapshot['num_rooms'];
        imageUrls = List<String>.from(hostelSnapshot['imageUrls']);
        bookedRooms = List<int>.from(hostelSnapshot['bookedRooms']);

        // Fetch the room type details
        DocumentSnapshot roomTypeSnapshot = await _firestore.collection('room_types').doc(roomTypeId).get();

        if (roomTypeSnapshot.exists) {
          roomType = roomTypeSnapshot['type'];  // Ensure this field exists in the room_types collection
        } else {
          errorMessage = 'Room type not found';
        }
      } else {
        errorMessage = 'Hostel not found';
      }
    } catch (error) {
      errorMessage = 'Failed to fetch hostel details: $error';
      print('Error fetching hostel details: $error'); // Log the error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> bookRoom(String userId, String hostelName, String roomType, int roomNumber) async {
    isLoading = true;
    notifyListeners();

    try {
      // Simulate booking process
      await Future.delayed(Duration(seconds: 2));

      errorMessage = 'Room booked successfully'; // Example message
    } catch (error) {
      errorMessage = 'Failed to book room: $error';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
