import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutterprojects/utils/constants.dart';


class BaseApiService {

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse('${Constants.apiBaseUrl}/$endpoint'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.apiBaseUrl}/$endpoint'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to post data: $e');
    }
  }

}
