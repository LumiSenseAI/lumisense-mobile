import 'package:flutter/material.dart';
import 'package:lumisense/services/add_object_service.dart';

class AddObjectPage extends StatefulWidget {
  @override
  _AddObjectPageState createState() => _AddObjectPageState();
}

class _AddObjectPageState extends State<AddObjectPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_controller.text.isEmpty) return;
    setState(() => _isLoading = true);

    bool success = await AddObjectService.addObject(_controller.text);
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Objet ajouté avec succès!', style: TextStyle(color: Colors.green))),
      );
      Navigator.pop(context); // Retour à la HomePage
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout de l\'objet.', style: TextStyle(color: Colors.red))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ajouter un Objet',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF92FDFF)),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nom de l\'objet',
                labelStyle: TextStyle(color: Color(0xFF92FDFF)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              child: _isLoading 
                  ? CircularProgressIndicator()
                  : Text('Ajouter', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF92FDFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}