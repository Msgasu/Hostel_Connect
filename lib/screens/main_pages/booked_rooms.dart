import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/screens/main_pages/homepage.dart';
import 'package:final_project/screens/main_pages/wishlist.dart';
import 'package:final_project/screens/sub_pages/profile.dart';
import 'package:final_project/widgets/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookedRoomsPage extends StatefulWidget {
  @override
  _BookedRoomsPageState createState() => _BookedRoomsPageState();
}

class _BookedRoomsPageState extends State<BookedRoomsPage> {
  int _currentIndex = 2; // Default index for the bottom nav bar to Booked Rooms

  void _onTabTapped(int index) {
    if (index == _currentIndex) return; // Avoid unnecessary navigation
    setState(() {
      _currentIndex = index;
    });
    Widget page;
    switch (index) {
      case 0:
        page = HomePage();
        break;
      case 1:
        page = WishlistPage();
        break;
      case 2:
        page = BookedRoomsPage();
        break;
      case 3:
        page = ProfilePage();
        break;
      default:
        page = HomePage(); // Default to HomePage if index is unknown
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<String> _getHostelName(String hostelId) async {
    try {
      final hostelDoc = await FirebaseFirestore.instance
          .collection('hostels')
          .doc(hostelId)
          .get();
      if (!hostelDoc.exists) {
        return 'Unknown Hostel';
      }
      final hostelData = hostelDoc.data() as Map<String, dynamic>;
      return hostelData['name'] ?? 'Unknown Hostel';
    } catch (e) {
      print('Error fetching hostel name: $e');
      return 'Unknown Hostel';
    }
  }

  Future<void> _deleteBooking(String bookingId) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Fetch the booking details
      final bookingDoc =
          await firestore.collection('bookings').doc(bookingId).get();

      if (!bookingDoc.exists) {
        throw Exception('Booking does not exist');
      }

      final bookingData = bookingDoc.data()!;
      final hostelId = bookingData['hostelId'] as String;
      final roomNumberToRemove =
          bookingData['roomNumber'] as int; // Ensure roomNumber is an int
      final roomTypeId = bookingData['roomId']
          as String; // Ensure correct type for roomType ID

      print('Hostel ID: $hostelId');
      print('Room Type ID: $roomTypeId');
      print('Room Number to Remove: $roomNumberToRemove');

      // Delete the booking
      await firestore.collection('bookings').doc(bookingId).delete();

      // Update room_types collection
      final roomTypeDocRef = firestore
          .collection('hostels')
          .doc(hostelId)
          .collection('room_types')
          .doc(roomTypeId);

      await firestore.runTransaction((transaction) async {
        final roomTypeDoc = await transaction.get(roomTypeDocRef);

        if (!roomTypeDoc.exists) {
          print('Room type document does not exist');
          throw Exception('Room type document does not exist');
        }

        final bookedRrooms =
            List<dynamic>.from(roomTypeDoc.data()?['bookedRrooms'] ?? []);
        final updatedBookedRrooms = <int>[];

        // Store the room number of the booking to be deleted
        final roomNumber = roomNumberToRemove;

        // Loop through the bookedRrooms array and remove the matching room number
        for (var room in bookedRrooms) {
          if (room != roomNumber) {
            updatedBookedRrooms.add(room);
          }
        }

        final currentFull = roomTypeDoc.data()?['full'] as int? ?? 0;
        final currentEmpty = roomTypeDoc.data()?['empty'] as int? ?? 0;

        transaction.update(roomTypeDocRef, {
          'bookedRrooms': updatedBookedRrooms,
          'full': currentFull > 0 ? currentFull - 1 : 0,
          'empty': currentEmpty + 1,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Booking deleted and room updated successfully')),
      );
    } catch (e) {
      print('Error deleting booking: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete booking: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        title: Text('Booked Rooms'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: keyboardHeight),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('bookings')
                    .where('userId',
                        isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final bookings = snapshot.data?.docs ?? [];
                  if (bookings.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/Nothing_Here_Yet.jpg'),
                          SizedBox(height: 16),
                          Text(
                            'No bookings available',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  }

                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: Future.wait(bookings.map((bookingDoc) async {
                      final booking = bookingDoc.data() as Map<String, dynamic>;
                      final hostelName =
                          await _getHostelName(booking['hostelId']);
                      return {
                        'bookingId': bookingDoc.id,
                        'hostelName': hostelName,
                        'roomNumber': booking['roomNumber'] ?? 'Unknown',
                        'roomType': booking['roomType'] ?? 'Unknown',
                        'paymentOption': booking['paymentOption'] ?? 'Unknown',
                        'paymentDate':
                            booking['paymentDate']?.toDate() ?? DateTime.now(),
                        'timestamp':
                            booking['timestamp']?.toDate() ?? DateTime.now(),
                      };
                    }).toList()),
                    builder: (context, futureSnapshot) {
                      if (futureSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (futureSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${futureSnapshot.error}'));
                      }

                      final bookingsWithHostelName = futureSnapshot.data ?? [];

                      return ListView.builder(
                        shrinkWrap: true, // Use shrinkWrap to fit content
                        itemCount: bookingsWithHostelName.length,
                        itemBuilder: (context, index) {
                          final booking = bookingsWithHostelName[index];
                          final bookingId = booking['bookingId'];
                          final hostelName = booking['hostelName'];
                          final roomNumber = booking['roomNumber'];
                          final roomType = booking['roomType'];
                          final paymentOption = booking['paymentOption'];
                          final paymentDate = booking['paymentDate'];
                          final timestamp = booking['timestamp'];

                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              title: Text(hostelName),
                              subtitle: Text(
                                'Room Number: $roomNumber\n'
                                'Room Type: $roomType\n'
                                'Payment Option: $paymentOption\n'
                                'Payment Date: ${paymentDate.toLocal()}\n'
                                'Date Booked: ${timestamp.toLocal()}',
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteBooking(bookingId),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
