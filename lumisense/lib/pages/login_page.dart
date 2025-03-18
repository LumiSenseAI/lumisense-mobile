import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumisense/services/auth_service.dart';
import 'package:lumisense/providers/user_provider.dart';
import 'package:lumisense/screens/delayed_animation.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    bool success = await AuthService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (success) {
      await context.read<UserProvider>().loadUserData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connexion réussie !')),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de la connexion. Vérifiez vos identifiants.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                DelayedAnimation(
                  delay: 200,
                  child: Text(
                    "Connexion",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF92FDFF),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                DelayedAnimation(
                  delay: 400,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "E-mail",
                      filled: true,
                      fillColor: Color(0xFF92FDFF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                DelayedAnimation(
                  delay: 600,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: "Mot de passe",
                      filled: true,
                      fillColor: Color(0xFF92FDFF),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                DelayedAnimation(
                  delay: 800,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF92FDFF),
                      foregroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _login,
                    child: Text("CONNEXION", style: TextStyle(fontSize: 12)),
                  ),
                ),
                SizedBox(height: 30),
                DelayedAnimation(
                  delay: 1000,
                  child: Image.asset("assets/images/lumisense.png", height: 80),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}