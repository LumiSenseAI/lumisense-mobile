import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumisense/providers/user_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Accueil'),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.logout),
      //       onPressed: () async {
      //         await AuthService.logout();
      //         userProvider.clearUser();
      //         Navigator.pushReplacementNamed(context, '/login');
      //       },
      //     ),
      //   ],
      // ),
      body: Center(
        child: userProvider.username != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Bienvenue, ${userProvider.username} !',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Email: ${userProvider.email}', style: TextStyle(fontSize: 16)),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}