import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final double appBarHeight; // Hauteur de l'AppBar reçue en paramètre
  final VoidCallback onClose;

  SideBar({required this.appBarHeight, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: MediaQuery.of(context).size.width, // Sidebar prend 75% de la largeur
      height: double.infinity,
      color: Colors.white,
      curve: Curves.easeInOut, // Animation fluide
      child: Column(
        children: [
          // Espacement pour aligner le contenu avec l'AppBar
          SizedBox(height: appBarHeight),

          // Le logo et la flèche pour fermer, avec une hauteur équivalente à l'AppBar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/elitlogosimple.png', // Le logo
                  width: 50,
                  height: 50,
                ),
                Spacer(), // Pour pousser la croix à droite
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: onClose, // Fermer la sidebar
                ),
              ],
            ),
          ),

          // Espacement entre les éléments
          SizedBox(height: 20),

          // Ajout des éléments du menu
          _buildMenuItem(Icons.network_check, "Network"),
          _buildMenuItem(Icons.security, "Security"),
          _buildMenuItem(Icons.work, "Workplace"),
          _buildMenuItem(Icons.people, "Managed Services"),
          _buildMenuItem(Icons.business, "Elit Technologies"),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[900]),
        title: Text(title),
        onTap: () {
          print("Navigating to $title");
        },
      ),
    );
  }
}