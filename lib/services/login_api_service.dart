import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<bool> login(String email, String password) async {
    final url = 'http://192.168.88.219:8000/hostelconnect_api/api/login_user_endpoint';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      // Print response status and body for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Debug: Print response data
        print('Response data: $responseData');
        // Check the response data to determine if login was successful
        return responseData['message'] == 'Login successful'; // Adjust based on your actual response
      } else {
        return false;
      }
    } catch (e) {
      // Debug: Print error
      print('An error occurred: $e');
      return false;
    }
  }
}
