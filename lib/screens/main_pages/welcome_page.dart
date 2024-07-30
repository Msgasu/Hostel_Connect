import 'package:flutter/material.dart';
import '../sub_pages/login_page.dart';
import '../sub_pages/signup_page.dart';
import 'dart:ui'; // Import for BackdropFilter

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Welcome to Hostel Booking App'),
      //   backgroundColor: Color.fromARGB(255, 245, 243, 243), // color for the app bar
      // ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/welcome.jpg",
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.2),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 220.0), // Add padding at the bottom of the "Welcome!" text
                      child: Text(
                        'Welcome!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 248, 247, 247), // Wine color for the text
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7.0), // Add vertical padding between "Welcome!" and buttons
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to login page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 114, 23, 23), // Wine color for the button
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Adjust button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0), // Set button border radius
                            side: BorderSide(color: const Color.fromARGB(255, 185, 179, 196), width: 2), // Add border side
                          ),
                          elevation: 5, // Add elevation for shadow effect
                          shadowColor: Colors.grey, // Set shadow color
                          minimumSize: Size(200, 50), // Set minimum width and height
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.white), // Increase font size and change text color
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0), // Add vertical padding between buttons
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to sign up page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 114, 23, 23), // Wine color for the button
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Adjust button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0), // Set button border radius
                            side: BorderSide(color: const Color.fromARGB(255, 185, 179, 196), width: 2), // Add border side
                          ),
                          elevation: 5, // Add elevation for shadow effect
                          shadowColor: Colors.grey, // Set shadow color
                          minimumSize: Size(200, 50), // Set minimum width and height
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 18, color: Colors.white), // Increase font size and change text color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
