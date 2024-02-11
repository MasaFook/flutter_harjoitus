// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_view.dart';

class Muistilaput extends StatelessWidget {
  const Muistilaput({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Muistilaput',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _noteController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  // Määrittele pastellivärit
  final List<Color> pastelColors = [
    const Color(0xFF9A5CA5),
    const Color(0xFFF18D9E),
    const Color(0xFFE5AC6D),
    const Color(0xFFA7D7C5),
    const Color(0xFFB2CCFF),
  ];

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  String generateUsernameFromEmail(String email) {
    // Tässä otetaan kaikki ennen '@'-merkkiä oleva osa sähköpostiosoitteesta
    return email.split('@')[0];
  }

  void _addNote() async {
    String noteText = _noteController.text.trim();
    if (noteText.isNotEmpty && _user != null) {
      try {
        // Tallenna context-muuttuja ennen asynkronista operaatiota
        BuildContext currentContext = context;

        String userName = generateUsernameFromEmail(_user!.email!);
        await _user!.updateDisplayName(userName);

        await _firestore.collection('muistilaput').add({
          'teksti': noteText,
          'userId': _user!.uid,
          'userName': userName,
          'timestamp': FieldValue.serverTimestamp(),
        });

        _noteController.clear();

        // Käytä tallennettua context-muuttujaa
        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(
            content: Text('Muistilapun lisäys onnistui'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print('Virhe muistiinpanon lisäyksessä: $e');
      }
    }
  }

  void _deleteNote(String noteId, String userId) {
    if (_user != null && userId == _user!.uid) {
      _firestore.collection('muistilaput').doc(noteId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Muistilapun poistaminen onnistui'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ei oikeutta poistaa tätä muistiinpanoa'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainView()),
                );
              },
            ),
            const Text('Muistilaput'),
          ],
        ),
      ),
      body: _user != null
          ? Column(
              children: [
                TextField(
                  controller: _noteController,
                  decoration:
                      const InputDecoration(labelText: 'Lisää muistilappu'),
                ),
                ElevatedButton(
                  onPressed: _addNote,
                  child: const Text('Lisää'),
                ),
                StreamBuilder(
                  stream: _firestore.collection('muistilaput').snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (!snapshot.hasData ||
                        snapshot.data == null ||
                        snapshot.data!.docs.isEmpty) {
                      return const Text('Ei muistiinpanoja');
                    }

                    var notes = snapshot.data!.docs;

                    for (var note in notes) {
                      print('Firestore Stream Note: ${note.data()}');
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          var note = notes[index];
                          print('Tallennettu userId: ${note['userId']}');
                          final pastelColor =
                              pastelColors[index % pastelColors.length];

                          return Card(
                            color: pastelColor,
                            child: ListTile(
                              title: Text(
                                note['teksti'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              subtitle: Text(
                                'Tekijä: ${note['userName'] ?? 'N/A'}',
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteNote(note.id, note['userId']);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
