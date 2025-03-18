// change_state_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ip_service.dart'; // Importer le service IP

class ChangeStateService {
  static Future<void> changeObjectState(String objectName) async {
    String ipAddress = await IPService.getIPAddress(); // Utiliser IPService pour obtenir l'adresse IP

    final url = 'http://localhost:3000/api/mqtt/change_state';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        'object_name': objectName,
        'ip_adress': ipAddress
      }),
    );

    if (response.statusCode == 200) {
      print('État de l\'objet changé avec succès');
    } else {
      throw Exception('Échec du changement d\'état de l\'objet');
    }
  }
}