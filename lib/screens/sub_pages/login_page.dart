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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form( // Wrap the form fields in a Form widget
              key: _formKey, // Set the key for the Form
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05), // 5% of available free space

                  // Welcome back text (centered)
                  Center(
                    child: Text(
                      'Welcome back!',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 40,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Prompt (Login to explore hostel options)
                  Center(
                    child: Text(
                      'Login to explore Hostel options',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: BorderSide(color: Color(0xFFF3F3F3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: BorderSide(color: Color(0xFFF2994A)),
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),

                        // Email TextFormField
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),

                        // Password TextFormField
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
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

                        SizedBox(height: 8),

                        // Forgot password button
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              // Implement forgot password functionality
                            },
                            child: Text(
                              'Forgot password?',
                              style: GoogleFonts.poppins(
                                color: Color(0xFF3D80DE),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16),

                        // Log in button
                        Center(
                          child: _isLoading
                              ? CircularProgressIndicator() // Show loading indicator when loading
                              : ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff0047AB), // Primary color for the button
                                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35.0),
                                      side: BorderSide(color: Color(0xFFB9B9C4), width: 2),
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
                            Text("Don't have an account? "),
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
                                  color: Colors.blue,
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
