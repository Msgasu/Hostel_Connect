import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class BookRoomPage extends StatefulWidget {
  final String userId;
  final String hostelId;
  final String roomTypeId;
  final int roomNumber;
  final String roomId;

  BookRoomPage({
    required this.userId,
    required this.hostelId,
    required this.roomTypeId,
    required this.roomNumber,
    required this.roomId,
  });

  @override
  _BookRoomPageState createState() => _BookRoomPageState();
}

class _BookRoomPageState extends State<BookRoomPage> {
  final _contactController = TextEditingController();
  bool _agreeToTerms = false;
  bool _bookingSuccess = false;
  bool _isLoading = false;
  Color _widgetColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _fetchHostelAndRoomTypeDetails(widget.hostelId, widget.roomTypeId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Book Room', style: GoogleFonts.poppins()),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Book Room', style: GoogleFonts.poppins()),
            ),
            body: Center(child: Text('Error: ${snapshot.error}', style: GoogleFonts.poppins())),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Book Room', style: GoogleFonts.poppins()),
            ),
            body: Center(child: Text('No data available', style: GoogleFonts.poppins())),
          );
        }

        final details = snapshot.data!;
        final hostelName = details['hostelName']!;
        final roomType = details['roomType']!;

        return Scaffold(
          appBar: AppBar(
            title: Text('Book Room', style: GoogleFonts.poppins()),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: _widgetColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hostel: $hostelName',
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Room Type: $roomType',
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Room Number: ${widget.roomNumber}',
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Contact Details:',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _contactController,
                    decoration: InputDecoration(
                      labelText: 'Enter your contact details',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreeToTerms = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'I agree to the terms and conditions',
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'By booking, you agree to our Terms and Conditions and Privacy Policy.',
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _agreeToTerms ? _bookRoom : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white) // Show loading indicator
                        : Text('Book Now', style: GoogleFonts.poppins(color: Colors.white)),
                  ),
                  SizedBox(height: 12),
                  if (_bookingSuccess)
                    Text(
                      'Booking successful!',
                      style: GoogleFonts.poppins(color: Colors.green, fontSize: 16),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, String>> _fetchHostelAndRoomTypeDetails(String hostelId, String roomTypeId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Fetch hostel name
      final hostelDoc = await firestore.collection('hostels').doc(hostelId).get();
      if (!hostelDoc.exists) {
        throw Exception('Hostel document does not exist');
      }
      final hostelName = hostelDoc.data()?['name'] as String;

      // Fetch room type name
      final roomTypeDoc = await firestore.collection('hostels').doc(hostelId).collection('room_types').doc(roomTypeId).get();
      if (!roomTypeDoc.exists) {
        throw Exception('Room type document does not exist');
      }
      final roomTypeName = roomTypeDoc.data()?['type'] as String;

      return {
        'hostelName': hostelName,
        'roomType': roomTypeName,
      };
    } catch (e) {
      throw Exception('Error fetching hostel and room type details: $e');
    }
  }

  Future<void> _bookRoom() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final firestore = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print('User is not authenticated');
        return;
      }

      final bookingRef = firestore.collection('bookings').doc();
      await bookingRef.set({
        'hostelId': widget.hostelId,
        'roomId': widget.roomId,  // Include roomId in the booking data
        'roomNumber': widget.roomNumber,  // If you still need to keep roomNumber
        'roomType': await _getRoomTypeName(widget.hostelId, widget.roomTypeId),
        'timestamp': FieldValue.serverTimestamp(),
        'userContact': _contactController.text,
        'userId': widget.userId,
      });

      // Update bookedRooms array and adjust full and empty counts
      final roomTypeDocRef = firestore
          .collection('hostels')
          .doc(widget.hostelId)
          .collection('room_types')
          .doc(widget.roomTypeId);

      await firestore.runTransaction((transaction) async {
        final roomTypeDoc = await transaction.get(roomTypeDocRef);
        if (!roomTypeDoc.exists) {
          throw Exception('Room type document does not exist');
        }

        final bookedRooms = List<dynamic>.from(roomTypeDoc.data()?['bookedRrooms'] ?? []);
        bookedRooms.add(widget.roomNumber);  // Add roomNumber to bookedRooms

        final currentFull = roomTypeDoc.data()?['full'] as int? ?? 0;
        final currentEmpty = roomTypeDoc.data()?['empty'] as int? ?? 0;

        transaction.update(roomTypeDocRef, {
          'bookedRrooms': bookedRooms,  // Update bookedRooms array
          'full': currentFull + 1,
          'empty': currentEmpty - 1,
        });
      });

      setState(() {
        _bookingSuccess = true;
        _widgetColor = Colors.red; // Change widget color to red
      });

      // Navigate back to the room details page
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context); // Adjust the delay if needed
      });
    } catch (e) {
      print('Error booking room: $e');
      setState(() {
        _bookingSuccess = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _getRoomTypeName(String hostelId, String roomTypeId) async {
    try {
      final roomTypeDoc = await FirebaseFirestore.instance.collection('hostels').doc(hostelId).collection('room_types').doc(roomTypeId).get();
      if (!roomTypeDoc.exists) {
        throw Exception('Room type document does not exist');
      }
      return roomTypeDoc.data()?['type'] as String;
    } catch (e) {
      throw Exception('Error fetching room type name: $e');
    }
  }

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }
}
