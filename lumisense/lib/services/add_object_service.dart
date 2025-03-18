import 'package:http/http.dart' as http;
import 'dart:convert';

class AddObjectService {
  static const String apiUrl = 'https://localhost:3000/api/objects';

  static Future<bool> addObject(String objectName) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': objectName}),
      );

      if (response.statusCode == 201) {
        return true; // Succès
      } else {
        return false; // Échec
      }
    } catch (e) {
      print('Erreur: $e');
      return false;
    }
  }
}