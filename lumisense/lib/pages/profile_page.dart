import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumisense/providers/user_provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nom: ${userProvider.username}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Email: ${userProvider.email}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}