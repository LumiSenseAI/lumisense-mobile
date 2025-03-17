import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumisense/providers/user_provider.dart';
import 'package:lumisense/pages/home_page.dart';
import 'package:lumisense/pages/profile_page.dart';
import 'package:lumisense/widgets/sidebar.dart';
import 'package:lumisense/services/auth_service.dart'; // Import AuthService

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isSidebarOpen = false;

  final List<Widget> _pages = [
    HomePage(),
    ProfilePage(),
  ];

  Future<void> _logout() async {
    await AuthService.logout(); // Supprimer le token
    Provider.of<UserProvider>(context, listen: false).clearUser(); // Effacer les infos utilisateur
    Navigator.pushReplacementNamed(context, '/login'); // Rediriger vers la page de connexion
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      _logout(); // Appel de la fonction logout
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.username == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    double appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      body: Stack(
        children: [
          // Contenu principal
          Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: _toggleSidebar, // Ouvrir/fermer la sidebar avec la flèche
              ),
            ),
            body: _pages[_selectedIndex],
          ),

          // Sidebar
          AnimatedPositioned(
            left: _isSidebarOpen ? 0 : -MediaQuery.of(context).size.width, 
            top: -25,
            bottom: kBottomNavigationBarHeight, 
            duration: Duration(milliseconds: 300), 
            curve: Curves.easeInOut, 
            child: GestureDetector(
              onTap: () {},
              child: SideBar(
                appBarHeight: appBarHeight, 
                onClose: _toggleSidebar, 
              ),
            ),
          ),

          // BottomNavigationBar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              backgroundColor: Colors.blue[900],
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey[300],
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explorer'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
                BottomNavigationBarItem(icon: Icon(Icons.exit_to_app), label: 'Déconnexion'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}