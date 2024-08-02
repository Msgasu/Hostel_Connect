import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/screens/main_pages/homepage.dart';
import 'package:final_project/screens/sub_pages/signup_page.dart';
import 'package:final_project/services/auth_service.dart'; // Import the AuthService
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add a GlobalKey for the Form
  bool _obscurePassword = true;
  bool _isLoading = false; // Add a loading state
  final AuthService _authService = AuthService(); // Create an instance of AuthService

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      await _authService.signin(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        context: context,
      );

      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    } else {
      // Show a snack bar or alert dialog if the form is not valid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   flexibleSpace: Center(
      //     child: Image.asset(
      //       'assets/logo.png', // Replace with your logo path
      //       height: 50, // Adjust height as needed
      //     ),
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.info_outline, color: Colors.black87),
      //       onPressed: () {
      //         // Handle icon press here
      //       },
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05), // 5% of available free space

                  // Logo
                  Center(
                    child: Image.asset(
                      'assets/splash.jpg', // Replace with your logo path
                      height: 100, // Adjust height as needed
                    ),
                  ),
                  SizedBox(height: 16),

                  // Welcome back text (centered)
                  Center(
                    child: Text(
                      'Welcome back!',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 36,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Prompt (Login to explore hostel options)
                  Center(
                    child: Text(
                      'Login to explore hostel options',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

                  // Sign in form
                  Theme(
                    data: ThemeData(
                      inputDecorationTheme: InputDecorationTheme(
                        filled: true,
                        fillColor: Color(0xFFFBFBFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Color.fromARGB(255, 172, 73, 33), width: 2),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email text
                        Text(
                          'Email',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),

                        // Email TextFormField
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            prefixIcon: Icon(Icons.email, color: Colors.grey[600]), // Add an email icon
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 24),

                        // Password text
                        Text(
                          'Password',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),

                        // Password TextFormField
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            prefixIcon: Icon(Icons.lock, color: Colors.grey[600]), // Add a lock icon
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey[600],
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Log in button
                        Center(
                          child: _isLoading
                              ? CircularProgressIndicator() // Show loading indicator when loading
                              : ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(255, 172, 73, 33), // Primary color for the button
                                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    elevation: 5,
                                    shadowColor: Colors.grey,
                                    minimumSize: Size(200, 50),
                                  ),
                                  child: Text(
                                    'Log in',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),

                        SizedBox(height: 16),

                        // Don't have an account? Sign up text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => SignUpPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign up',
                                style: GoogleFonts.poppins(
                                  color: Color.fromARGB(255, 172, 73, 33),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
