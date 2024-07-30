import 'package:flutter/material.dart';
import '../../services/login_api_service.dart'; 
import '../main_pages/homepage.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Debug: Print login details
        print('Attempting to login with Email: $_email and Password: $_password');

        bool success = await ApiService.login(_email, _password);
        
        // Debug: Print login result
        print('Login success: $success');
        
        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed. Please check your credentials.')),
          );
        }
      } catch (e) {
        // Debug: Print error
        print('An error occurred: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                Center(
                  child: Text(
                    'Welcome back!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 40,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 16),

                Center(
                  child: Text(
                    'Login to explore Hostel options',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(height: 32),

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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter your Email',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          onSaved: (value) => _email = value!,
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Password',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
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
                            return null;
                          },
                          onSaved: (value) => _password = value!,
                        ),
                        SizedBox(height: 8),
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
                        Center(
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 114, 23, 23),
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35.0),
                                side: BorderSide(
                                  color: Color.fromARGB(255, 185, 179, 196),
                                  width: 2,
                                ),
                              ),
                              elevation: 5,
                              shadowColor: Colors.grey,
                              minimumSize: Size(200, 50),
                            ),
                            child: Text(
                              'Log in',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account? "),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignUpPage()),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
