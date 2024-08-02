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
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      print('Yanıt gövdesi: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return json.decode(response.body);
        } catch (e) {
          throw Exception('Yanıt JSON formatında değil: ${response.body}');
        }
      } else {
        throw Exception('Veri gönderme başarısız: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Hata: $e');
      throw Exception('Veri gönderme başarısız: $e');
    }
  }


}
