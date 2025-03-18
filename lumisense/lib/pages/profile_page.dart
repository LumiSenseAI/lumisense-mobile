import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumisense/providers/user_provider.dart';
import 'package:lumisense/services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    await AuthService.logout();
    Provider.of<UserProvider>(context, listen: false).clearUser();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nom: ${userProvider.username}', style: TextStyle(fontSize: 20, color: Color(0xFF92FDFF))),
            SizedBox(height: 10),
            Text('Email: ${userProvider.email}', style: TextStyle(fontSize: 16, color: Color(0xFF92FDFF))),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 175, 81, 76), // Définir la couleur de fond du bouton (ton bleu ici)
              ),
              child: Text(
                'Déconnexion',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black, // Couleur du texte en blanc
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}