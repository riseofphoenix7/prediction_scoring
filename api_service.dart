import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl =
      'http://127.0.0.1:8000'; // Update this with your actual server's IP or domain

  Future<double?> getCompanyRating({
    required double revenue,
    required double income,
  }) async {
    // Endpoint for the prediction API
    final String endpoint = '/predict/';

    // Create the request body
    final Map<String, dynamic> requestBody = {
      "revenue": revenue,
      "income": income,
    };

    try {
      // Send a POST request to the API
      final response = await http.post(
        Uri.parse(baseUrl + endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response body and return the predicted rating
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        return responseBody['predicted_rating'];
      } else {
        print('Failed to fetch rating. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
