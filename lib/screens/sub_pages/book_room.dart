import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
  String _paymentOption = 'Mobile Money';
  DateTime? _selectedPaymentDate;

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
          body: SingleChildScrollView(
            child: Padding(
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

                    // Terms and Conditions ExpansionTile
                    ExpansionTile(
                      title: Text(
                        'Terms and Conditions',
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Please read and agree to our Terms and Conditions before booking. \n\n'
                            '1. Your booking is subject to availability.\n'
                            '2. Payments must be made within the specified period.\n'
                            '3. Cancellations must be done at least 24 hours before the check-in time.\n'
                            '4. All bookings are non-transferable.\n'
                            '5. The hostel is not responsible for any loss or damage during your stay.\n',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Contact Details
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
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 24),

                    // Payment Option
                    Text(
                      'Payment Option:',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _paymentOption,
                      items: [
                        DropdownMenuItem(value: 'Mobile Money', child: Row(children: [Icon(Icons.phone_android), SizedBox(width: 8), Text('Mobile Money')])),
                        DropdownMenuItem(value: 'Bank Account', child: Row(children: [Icon(Icons.account_balance), SizedBox(width: 8), Text('Bank Account')])),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _paymentOption = value!;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Payment Date
                    Text(
                      'Payment Date:',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: TextEditingController(text: _selectedPaymentDate != null ? DateFormat('yyyy-MM-dd').format(_selectedPaymentDate!) : ''),
                      decoration: InputDecoration(
                        labelText: 'Select payment date',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (selectedDate != null && selectedDate != _selectedPaymentDate) {
                          setState(() {
                            _selectedPaymentDate = selectedDate;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 24),

                    // Terms and Conditions Checkbox
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

                    // Book Now Button
                    Center(
                      child: ElevatedButton(
                        onPressed: _agreeToTerms ? _bookRoom : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 172, 73, 33),
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Book Now', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
                      ),
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

    // Create booking document
    final bookingRef = firestore.collection('bookings').doc();
    final bookingData = {
      'userId': widget.userId,
      'hostelId': widget.hostelId,
      'roomId': widget.roomId,
      'roomNumber': widget.roomNumber,  // Add room number
      'roomType': await _getRoomTypeName(widget.hostelId, widget.roomTypeId),  // Add room type
      'contact': _contactController.text,
      'paymentOption': _paymentOption,
      'paymentDate': _selectedPaymentDate != null ? Timestamp.fromDate(_selectedPaymentDate!) : null,
      'timestamp': Timestamp.now(),
    };
    await bookingRef.set(bookingData);

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

      final totalRooms = roomTypeDoc.data()?['totalRooms'] as int? ?? 0;
      final currentFull = roomTypeDoc.data()?['full'] as int? ?? 0;
      final currentEmpty = totalRooms - currentFull;

      transaction.update(roomTypeDocRef, {
        'bookedRrooms': bookedRooms,  // Update bookedRooms array
        'full': currentFull + 1,
        'empty': currentEmpty - 1,
      });
    });

    setState(() {
      _bookingSuccess = true;
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
