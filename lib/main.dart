import 'package:final_project/providers/hostel_provider.dart';
import 'package:final_project/screens/main_pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HostelProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostel Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Initial screen
      debugShowCheckedModeBanner: false,
    );
  }
}