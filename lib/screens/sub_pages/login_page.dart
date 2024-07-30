import 'package:final_project/screens/main_pages/homepage.dart';
import 'package:flutter/material.dart';
import '../sub_pages/signup_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.05), // 5% of available free space

                // Welcome back text (centered)
                Center(    
                  child: 
                  Text('Welcome back!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600,fontSize:40),
                  textAlign: TextAlign.center,
                  )
                  ),
            
                SizedBox(height: 16),

                //prompt(Login to explore hostel options)
                Center(
                  child: 
                   Text(
                  'Login to explore Hostel options',
                  style: TextStyle(fontSize: 16, fontWeight:FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),

                      // Email TextFormField
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter your Email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          // You can add more validation logic as needed
                          return null;
                        },
                      ),

                      SizedBox(height: 24),

                      // Password text
                      Text(
                        'Password',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),

                      // Password TextFormField
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.visibility),
                            onPressed: () {
                              // Implement show/hide password functionality
                            },
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          // You can add more validation logic as needed
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
                            style: TextStyle(color: Color(0xFF3D80DE)),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Log in button
                      Center(
                        child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage(),)
                            );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(
                              255, 114, 23, 23), // Wine color for the button
                          padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15), // Adjust button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                35.0), // Set button border radius
                            side: BorderSide(
                                color: Color.fromARGB(255, 185, 179, 196),
                                width: 2), // Add border side
                          ),
                          elevation: 5, // Add elevation for shadow effect
                          shadowColor: Colors.grey, // Set shadow color
                          minimumSize:
                              Size(200, 50), // Set minimum width and height
                        ),
                        child: Text(
                          'Log in',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors
                                  .white), // Increase font size and change text color
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
                                    builder: (context) => SignUpPage()),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
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
    );
  }
}

