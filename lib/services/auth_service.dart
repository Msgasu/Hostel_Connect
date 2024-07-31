import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/screens/main_pages/homepage.dart';
import 'package:final_project/screens/sub_pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return regex.hasMatch(email);
  }

  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String gender,
    required String contact,
  }) async {
    if (!_isValidEmail(email)) {
      _showSnackBar(context, 'Invalid email format.');
      return;
    }

    try {
      // Create user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user ID
      String uid = userCredential.user!.uid;

      // Save additional user information in Firestore with the user ID as the document ID
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'contact': contact,
        'uid': uid,
      });

      // Show success message
      _showSnackBar(context, 'Registration successful!');

      // Delay for a moment to show the success message
      await Future.delayed(const Duration(seconds: 1));

      // Redirect to home page after registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginPage(),
        ),
      );
      
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is badly formatted.';
      }
      _showSnackBar(context, message);
    } catch (e) {
      _showSnackBar(context, 'An error occurred. Please try again.');
    }
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        ),
      );
      
    } on FirebaseAuthException catch (e) {
      String message = '';
      switch (e.code) {
        case 'invalid-email':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided for that user.';
          break;
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'user-disabled':
          message = 'User account has been disabled.';
          break;
        case 'too-many-requests':
          message = 'Too many requests. Try again later.';
          break;
        case 'operation-not-allowed':
          message = 'Operation not allowed. Please contact support.';
          break;
        default:
          message = 'An unknown error occurred.';
      }
      _showSnackBar(context, message);
    } catch (e) {
      _showSnackBar(context, 'An error occurred. Please try again.');
    }
  }

  Future<void> signout({
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signOut();
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginPage(),
        ),
      );
    } catch (e) {
      _showSnackBar(context, 'An error occurred during sign out. Please try again.');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.red, // Set text color to red
          ),
        ),
        backgroundColor: Colors.white, // Set background color to white
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
