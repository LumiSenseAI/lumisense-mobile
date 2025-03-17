import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String _apiUrl = 'http://10.105.102.16:8000/api/login_check';
  
  static Future<bool> login(String email, String password) async {
    print(_apiUrl);
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String token = data['token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);

      return true;
    } else {
      return false;
    }
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token != null) {
      try {
        Map<String, dynamic> decodedToken = jsonDecode(
            ascii.decode(base64.decode(base64.normalize(token.split(".")[1]))));

        return decodedToken;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

 static Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token != null) {
      try {
        Map<String, dynamic> decodedToken = jsonDecode(
            ascii.decode(base64.decode(base64.normalize(token.split(".")[1]))));

        if (decodedToken.containsKey('exp')) {
          int expirationTime = decodedToken['exp'];
          DateTime expirationDate = DateTime.fromMillisecondsSinceEpoch(expirationTime * 1000);

          if (expirationDate.isBefore(DateTime.now())) {
            return false;
          }

          return true;
        }
      } catch (e) {
        return false;
      }
    }

    return false;
  }
}