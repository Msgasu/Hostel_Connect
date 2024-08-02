import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/screens/sub_pages/login_page.dart';
import 'package:final_project/services/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _selectedGender = 'Male'; // Default value for gender

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
/// The above code is likely written in Dart and it is calling the `dispose()` method on the
/// `_contactController` object. This method is commonly used to release resources or perform cleanup
/// operations when an object is no longer needed.
    // _contactController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    resizeToAvoidBottomInset: true,
    bottomNavigationBar: _signin(context),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 50,
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 600;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/splash.jpg',
                        width: 60, // Adjust size as needed
                        height: 60,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Register Account',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  isWide
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: _firstName()),
                            const SizedBox(width: 16),
                            Expanded(child: _lastName()),
                          ],
                        )
                      : Column(
                          children: [
                            _firstName(),
                            const SizedBox(height: 16),
                            _lastName(),
                          ],
                        ),
                  const SizedBox(height: 16),
                  _gender(),
                  const SizedBox(height: 16),
                  _emailAddress(),
                  const SizedBox(height: 16),
                  // _contactNumber(),
                  // const SizedBox(height: 20),
                  _password(),
                  const SizedBox(height: 20),
                  _confirmPassword(),
                  const SizedBox(height: 50),
                  _signup(context),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}


  Widget _firstName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'First Name',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _firstNameController,
          decoration: InputDecoration(
            filled: true,
            hintText: 'John',
            hintStyle: const TextStyle(
              color: Color(0xff6A6A6A),
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your first name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _lastName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Last Name',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _lastNameController,
          decoration: InputDecoration(
            filled: true,
            hintText: 'Doe',
            hintStyle: const TextStyle(
              color: Color(0xff6A6A6A),
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your last name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _gender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          decoration: InputDecoration(
            filled: true,
            hintText: 'Select Gender',
            hintStyle: const TextStyle(
              color: Color(0xff6A6A6A),
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          items: <String>['Male', 'Female'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedGender = newValue;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _emailAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            filled: true,
            hintText: 'johndoe@gmail.com',
            hintStyle: const TextStyle(
              color: Color(0xff6A6A6A),
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email address';
            }
            final RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
            if (!emailRegExp.hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  // Widget _contactNumber() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Contact Number',
  //         style: GoogleFonts.poppins(
  //           textStyle: const TextStyle(
  //             color: Colors.black,
  //             fontWeight: FontWeight.normal,
  //             fontSize: 16,
  //           ),
  //         ),
  //       ),
  //       const SizedBox(height: 16),
  //       TextFormField(
  //         controller: _contactController,
  //         decoration: InputDecoration(
  //           filled: true,
  //           hintText: '+2334567890',
  //           hintStyle: const TextStyle(
  //             color: Color(0xff6A6A6A),
  //             fontWeight: FontWeight.normal,
  //             fontSize: 14,
  //           ),
  //           fillColor: const Color(0xffF7F7F9),
  //           border: OutlineInputBorder(
  //             borderSide: BorderSide.none,
  //             borderRadius: BorderRadius.circular(14),
  //           ),
  //         ),
  //         keyboardType: TextInputType.phone,
  //         validator: (value) {
  //           if (value == null || value.isEmpty) {
  //             return 'Please enter your contact number';
  //           }
  //           final RegExp phoneRegExp = RegExp(r'^\+?[1-9]\d{1,14}$');
  //           if (!phoneRegExp.hasMatch(value)) {
  //             return 'Please enter a valid contact number';
  //           }
  //           return null;
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _password() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            filled: true,
            hintText: '••••••••',
            hintStyle: const TextStyle(
              color: Color(0xff6A6A6A),
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _confirmPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Password',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            filled: true,
            hintText: '••••••••',
            hintStyle: const TextStyle(
              color: Color(0xff6A6A6A),
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

Widget _signup(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 172, 73, 33),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: () async {
        if (_passwordController.text == _confirmPasswordController.text) {
          await AuthService().signup(
            email: _emailController.text,
            password: _passwordController.text,
            context: context,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            gender: _selectedGender,
            // contact: _contactController.text,
          );
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Passwords do not match')),
          );
        }
      },
      child: const Text(
  "Sign Up",
  style: TextStyle(
    color: Colors.black, // Set the text color to black
  ),
),

    );
  }


  Widget _signin(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an account? ',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            TextSpan(
              text: 'Sign In',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color:  Color.fromARGB(255, 172, 73, 33),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
