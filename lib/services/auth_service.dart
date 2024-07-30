import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/screens/main_pages/homepage.dart';
import 'package:final_project/screens/sub_pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  // Future<void> signup({
  //   required String email,
  //   required String password,
  //   required BuildContext context,
  //   required String firstName,
  //   required String lastName,
  //   required String gender,
  //   required String contact,
  // }) async {
  //   try {
  //     // Create user with Firebase Authentication
  //     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     // Get the user ID
  //     String uid = userCredential.user!.uid;

  //     // Save additional user information in Firestore with the user ID as the document ID
  //     await FirebaseFirestore.instance.collection('users').doc(uid).set({
  //       'email': email,
  //       'firstName': firstName,
  //       'lastName': lastName,
  //       'gender': gender,
  //       'contact': contact,
  //       'createdAt': Timestamp.now(),
  //       'uid': uid,
  //     });

  //     await Future.delayed(const Duration(seconds: 1));
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (BuildContext context) => HomePage(),
  //       ),
  //     );
      
  //   } on FirebaseAuthException catch (e) {
  //     String message = '';
  //     if (e.code == 'weak-password') {
  //       message = 'The password provided is too weak.';
  //     } else if (e.code == 'email-already-in-use') {
  //       message = 'An account already exists with that email.';
  //     }
  //     Fluttertoast.showToast(
  //       msg: message,
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.SNACKBAR,
  //       backgroundColor: Colors.black54,
  //       textColor: Colors.white,
  //       fontSize: 14.0,
  //     );
  //   } catch (e) {
  //     Fluttertoast.showToast(
  //       msg: 'An error occurred. Please try again.',
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.SNACKBAR,
  //       backgroundColor: Colors.black54,
  //       textColor: Colors.white,
  //       fontSize: 14.0,
  //     );
  //   }
  // }

  // Future<void> signin({
  //   required String email,
  //   required String password,
  //   required BuildContext context,
  // }) async {
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     await Future.delayed(const Duration(seconds: 1));
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (BuildContext context) => HomePage(),
  //       ),
  //     );
      
  //   } on FirebaseAuthException catch (e) {
  //     String message = '';
  //     if (e.code == 'invalid-email') {
  //       message = 'No user found for that email.';
  //     } else if (e.code == 'wrong-password') {
  //       message = 'Wrong password provided for that user.';
  //     }
  //     Fluttertoast.showToast(
  //       msg: message,
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.SNACKBAR,
  //       backgroundColor: Colors.black54,
  //       textColor: Colors.white,
  //       fontSize: 14.0,
  //     );
  //   } catch (e) {
  //     Fluttertoast.showToast(
  //       msg: 'An error occurred. Please try again.',
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.SNACKBAR,
  //       backgroundColor: Colors.black54,
  //       textColor: Colors.white,
  //       fontSize: 14.0,
  //     );
  //   }
  // }

  // Future<void> signout({
  //   required BuildContext context,
  // }) async {
  //   await FirebaseAuth.instance.signOut();
  //   await Future.delayed(const Duration(seconds: 1));
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (BuildContext context) => LoginPage(),
  //     ),
  //   );
  // }
}
