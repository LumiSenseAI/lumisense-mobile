import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';  // Pour récupérer le token

class ObjectService {
  static const String apiUrl = 'http://localhost:3000/api/object';

  static Future<List<dynamic>> fetchObjects() async {
    try {
      // Récupérer le token JWT à partir de SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      // Si le token n'est pas disponible, on lance une exception
      if (token == null) {
        throw Exception('Token is missing');
      }

      // Ajouter le token dans l'en-tête Authorization (Bearer Token)
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',  // Ajouter l'en-tête avec le token
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        List<dynamic> objects = jsonDecode(response.body);
        return objects;
      } else {
        throw Exception('Failed to load objects');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}