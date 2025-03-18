import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumisense/providers/user_provider.dart';
import 'package:lumisense/pages/home_page.dart';
import 'package:lumisense/pages/profile_page.dart';
import 'package:lumisense/pages/add_object.dart';
import 'package:lumisense/services/audio_service.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isAddingObject = false;
  bool _isRecording = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isAddingObject = false;
    });
  }

  void _onAddObjectTapped() {
    setState(() {
      _isAddingObject = true;
    });
  }

  void _startRecording() async {
    setState(() {
      _isRecording = true;
    });
    await AudioService.startRecording();
    setState(() {
      _isRecording = false;
    });
  }

  void _stopRecording() async {
    await AudioService.stopRecording();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.username == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/lumisense.png',
            width: 70,
            height: 70,
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Color(0xFF92FDFF)),
            onPressed: _onAddObjectTapped,
          ),
        ],
      ),
      body: Center(
        child: _isAddingObject
            ? AddObjectPage()
            : _selectedIndex == 0
                ? HomePage()
                : _selectedIndex == 1
                    ? Container() // Placeholder for recording UI
                    : ProfilePage(),
      ),
      bottomNavigationBar: Container(
        height: 65,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFF92FDFF),
              width: 2,
            ),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Color.fromARGB(255, 30, 30, 30),
          selectedItemColor: Color(0xFF92FDFF),
          unselectedItemColor: Color(0xFF92FDFF),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.house),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onLongPressStart: (details) {
                  _startRecording();
                },
                onLongPressEnd: (details) {
                  _stopRecording();
                },
                child: Icon(
                  _isRecording ? Icons.stop_circle : Icons.mic,
                  color: _isRecording ? Colors.red : Color(0xFF92FDFF),
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}