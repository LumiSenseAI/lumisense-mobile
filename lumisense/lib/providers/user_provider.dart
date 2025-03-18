import 'package:flutter/material.dart';
import 'package:lumisense/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  String? username;
  String? email;
  String? role;

  Future<void> loadUserData() async {
    if (email != null && username != null) return;
    
    var userData = await AuthService.getUserData();

    if (userData != null) {
      email = userData['email'];
      username = userData['username'];
      role = userData['role'];

      print("Utilisateur chargé: $username, Email: $email");
      
      notifyListeners();
    } else {
      print("Aucune donnée utilisateur trouvée.");
    }
  }

  void clearUser() {
    username = null;
    email = null;
    role = null;
    notifyListeners();
  }
}