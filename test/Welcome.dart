import 'package:flutter/material.dart';
import '../sub_pages/login_page.dart';
import '../sub_pages/signup_page.dart';
import 'dart:ui'; // Import for BackdropFilter

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Card(
                  elevation: 10, // Add elevation to the card for a shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Rounded corners for the card
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20), // Adjust margin for the card
                  child: Padding(
                    padding: const EdgeInsets.all(20.0), // Add padding inside the card
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Set to min to wrap content
                      mainAxisAlignment: MainAxisAlignment.center, // Center children vertically
                      children: <Widget>[
                        Text(
                          'Welcome!\nExplore and book your hostel from the comfort of your room\n\n\n',
                          textAlign: TextAlign.center, // Center align the text horizontally
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0), // Wine color for the text
                          ),
                        ),
                        SizedBox(height: 20), // Add space between text and buttons
                        ElevatedButton(
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
                        SizedBox(height: 10),
                        ElevatedButton(
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
