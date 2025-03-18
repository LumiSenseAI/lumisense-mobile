import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumisense/providers/user_provider.dart';
import 'package:lumisense/services/object_service.dart';
import 'package:lumisense/services/change_state_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return FutureBuilder(
      future: userProvider.loadUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError || userProvider.username == null) {
          return Scaffold(body: Center(child: Text("Erreur de chargement")));
        }

        // Afficher les objets via ObjectService
        return Scaffold(
          body: Center(
            // Centrer tout le contenu de la page
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 50.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Texte de bienvenue
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Bienvenue, ${userProvider.username} !',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF92FDFF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // FutureBuilder pour charger et afficher les objets
                    FutureBuilder<List<dynamic>>(
                      future: ObjectService.fetchObjects(),
                      builder: (context, objectsSnapshot) {
                        if (objectsSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (objectsSnapshot.hasError) {
                          return Center(
                            child: Text("Erreur de chargement des objets"),
                          );
                        }
                        if (!objectsSnapshot.hasData || objectsSnapshot.data!.isEmpty) {
                          return Center(child: Text("Aucun objet trouvé"));
                        }
                        // Affichage des objets avec Wrap pour une disposition fluide
                        List<dynamic> objects = objectsSnapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children: objects.map((object) {
                              return GestureDetector(
                                onTap: () async {
                                  if (object['type'] != null) {
                                    await ChangeStateService.changeObjectState(object['type']);
                                    // Rafraîchir la liste des objets après le changement d'état
                                    setState(() {});
                                  } else {
                                    print('Object name is null');
                                  }
                                },
                                child: Container(
                                  width: 110,
                                  height: 130,
                                  child: Card(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.transparent,
                                              border: Border.all(
                                                color: object['state'] ?? false ? const Color.fromARGB(255, 76, 175, 111) : Colors.grey,
                                                width: 3,
                                              ),
                                            ),
                                            child: Icon(
                                              object['state'] ?? false ? Icons.lightbulb : Icons.lightbulb_outline,
                                              color: object['state'] ?? false ? const Color.fromARGB(255, 76, 175, 111) : Colors.grey,
                                              size: 30,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            width: double.infinity,
                                            child: Text(
                                              object['type'],
                                              style: TextStyle(color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}