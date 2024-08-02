import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/screens/main_pages/homepage.dart';
import 'package:final_project/screens/sub_pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('Fetching data for user: ${user.uid}');
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        print('User data: $userData');
        setState(() {
          _name = userData?['firstName'] ?? '';
          _email = userData?['email'] ?? '';
          // Uncomment if profile image URL is stored
          // _profileImage = userData?['profileImageUrl'] != null ? File(userData['profileImageUrl']) : null;
        });
      } else {
        print('User document does not exist');
      }
    } else {
      print('No user is currently signed in');
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'firstName': _name,
            'email': _email,
            // Update profile image URL if needed
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully!')),
          );
          _fetchUserData(); // Refresh data after update
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile: $e')),
          );
        }
      }
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.openSans(),
        ),
        backgroundColor: Color.fromARGB(255, 230, 225, 225), // Light color
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()),
          ), // Navigate back to the previous page
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : AssetImage('assets/Nothing_Here_Yet.jpg')
                            as ImageProvider,
                  ),
                  SizedBox(height: 10),
                  Text(
                    _name,
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextFormField(
                            initialValue: _name,
                            decoration: InputDecoration(
                              hintText: 'Enter your name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            onSaved: (value) => _name = value!,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Email',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextFormField(
                            initialValue: _email,
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            onSaved: (value) => _email = value!,
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: _updateProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 172, 73, 33), // Light color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                elevation: 5,
                              ),
                              child: Text(
                                'Update Profile',
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
