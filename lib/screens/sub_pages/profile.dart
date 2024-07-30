import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = 'John Doe';
  String _email = 'john.doe@example.com';

  void _editProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Handle profile update logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color.fromARGB(255, 114, 23, 23), // Wine color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/profile_image.jpg'),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              SizedBox(height: 20),
              Text(
                'Email',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _editProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 114, 23, 23), // Wine color
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Update Profile',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
