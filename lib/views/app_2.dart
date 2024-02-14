import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'dart:ui' as ui;

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
    return email.split('@')[0];
  }

  void _addNote() async {
    String noteText = _noteController.text.trim();
    if (noteText.isNotEmpty && _user != null) {
      try {
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

        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(
            content: Text('Muistilapun lisäys onnistui'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print('Virhe muistilapun lisäyksessä: $e');
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

  Future<void> _shareNote(String noteId, String noteText) async {
    try {
      if (_user != null) {
        // Hae muistilapun tiedot
        DocumentSnapshot<Map<String, dynamic>> noteSnapshot =
            await _firestore.collection('muistilaput').doc(noteId).get();

        // Tarkista, onko käyttäjä muistilapun tekijä
        if (noteSnapshot.exists &&
            noteSnapshot.data()!['userId'] == _user!.uid) {
          Share.share(noteText);
        } else {
          print('Käyttäjällä ei ole oikeuksia jakaa tätä muistilappua');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ei oikeuksia jakaa tätä muistilappua'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Virhe muistilapun jakamisessa: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Muistilapun jakaminen epäonnistui'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showEditDialog(String noteId, String currentText) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController editController =
            TextEditingController(text: currentText);
        return AlertDialog(
          title: const Text('Muokkaa muistilappua'),
          content: TextField(
            controller: editController,
            decoration:
                const InputDecoration(labelText: 'Muokkaa muistilappua'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Peruuta'),
            ),
            TextButton(
              onPressed: () {
                _editNote(noteId, editController.text);
                Navigator.pop(context);
              },
              child: const Text('Tallenna muutokset'),
            ),
          ],
        );
      },
    );
  }

  void _editNote(String noteId, String newText) {
    if (_user != null) {
      _firestore.collection('muistilaput').doc(noteId).get().then((document) {
        if (document.exists) {
          if (_user!.uid == document.data()!['userId']) {
            _firestore.collection('muistilaput').doc(noteId).update({
              'teksti': newText,
              'timestamp': FieldValue.serverTimestamp(),
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Muistilapun muokkaus onnistui'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ei oikeutta muokata tätä muistilappua'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      }).catchError((error) {
        print('Virhe muistilapun haussa: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Muistilaput')),
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
                      return const Text('Ei muistilappuja');
                    }

                    var notes = snapshot.data!.docs;

                    return Expanded(
                      child: ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          var note = notes[index];
                          final pastelColor =
                              pastelColors[index % pastelColors.length];

                          // Tarkista, onko käyttäjä alkuperäisen muistiinpanon tekijä
                          bool isNoteCreator = _user!.uid == note['userId'];

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
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Muokkauskuvake
                                  if (isNoteCreator)
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        _showEditDialog(
                                            note.id, note['teksti']);
                                      },
                                    ),
                                  // Poistokuvake
                                  if (isNoteCreator)
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteNote(note.id, note['userId']);
                                      },
                                    ),
                                  if (isNoteCreator)
                                    IconButton(
                                        icon: const Icon(Icons.share),
                                        onPressed: () {
                                          _shareNote(
                                              note.id, note.data()!['teksti']);
                                        })
                                ],
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
