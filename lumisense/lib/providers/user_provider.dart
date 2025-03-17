import 'package:flutter/material.dart';
import 'package:lumisense/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  String? username;
  String? email;
  List<String>? roles; // Use List<String> for roles as it contains an array of strings
  int? entrepriseId; // Use int for entrepriseId
  int? holdingId; // Use int for holdingId

  Future<void> loadUserData() async {
    var userData = await AuthService.getUserData();
    if (userData != null) {
      print('Données utilisateur chargées: $userData');
      username = userData['userFirstName'];
      email = userData['username'];
      roles = List<String>.from(userData['roles'] ?? []);
      entrepriseId = userData['entrepriseId'];
      holdingId = userData['holdingId'];
      notifyListeners();
    }
  }

  void clearUser() {
    username = null;
    email = null;
    roles = null;
    entrepriseId = null;
    holdingId = null;
    notifyListeners();
  }
}