import 'package:final_project/screens/main_pages/homepage.dart';
import 'package:final_project/screens/sub_pages/login_page.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHomePage();
  }

  void _navigateToHomePage() async {
    await Future.delayed(Duration(seconds: 3)); 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/splash.jpg'), // Add your splash screen image here
            SizedBox(height: 20),
            Text(
              'Loading...', // Splash screen text
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
