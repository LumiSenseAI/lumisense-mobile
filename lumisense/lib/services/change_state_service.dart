import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Importer pour récupérer le token
import 'ip_service.dart'; // Importer le service IP
import 'object_service.dart'; // Importer le service ObjectService pour récupérer la liste des objets

class ChangeStateService {
  static Future<void> changeObjectState(String objectName) async {
    try {
      // Récupérer l'adresse IP depuis IPService
      String ipAddress = await IPService.getIPAddress();

      // Récupérer le token JWT depuis SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('Token is missing');
      }

      final url = 'http://localhost:3000/api/mqtt/change_state';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', 
        },
        body: jsonEncode(<String, String>{
          'object_name': objectName,
          'ip_adress': ipAddress
        }),
      );

      if (response.statusCode == 200) {
        print('État de l\'objet changé avec succès');

        // Une fois l'état changé avec succès, on rafraîchit la liste des objets
        await ObjectService.fetchObjects();  // Rafraîchir les objets
      } else {
        print('Erreur côté serveur: ${response.statusCode} - ${response.body}');
        throw Exception('Échec du changement d\'état de l\'objet');
      }
    } catch (e) {
      print('Erreur: $e');
      throw Exception('Erreur lors du changement d\'état: $e');
    }
  }
}
