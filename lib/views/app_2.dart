import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_view.dart';

class Muistilaput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muistilaput',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
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
    Color(0xFF9A5CA5),
    Color(0xFFF18D9E),
    Color(0xFFE5AC6D),
    Color(0xFFA7D7C5),
    Color(0xFFB2CCFF),
  ];

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  void _addNote() {
    String noteText = _noteController.text.trim();
    if (noteText.isNotEmpty && _user != null) {
      _firestore.collection('muistilaput').add({
        'teksti': noteText,
        'userId': _user!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _noteController.clear();
    }
  }

  void _deleteNote(String noteId) {
    _firestore.collection('muistilaput').doc(noteId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainView()),
                );
              },
            ),
            Text('Muistilaput'),
          ],
        ),
      ),
      body: _user != null
          ? Column(
              children: [
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: 'Lisää muistilappu'),
                ),
                ElevatedButton(
                  onPressed: _addNote,
                  child: Text('Lisää'),
                ),
                StreamBuilder(
                  stream: _firestore
                      .collection('muistilaput')
                      .where('userId', isEqualTo: _user!.uid)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (!snapshot.hasData ||
                        snapshot.data == null ||
                        snapshot.data!.docs.isEmpty) {
                      return Text('Ei muistiinpanoja');
                    }

                    var notes = snapshot.data!.docs;

                    return Expanded(
                      child: ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          var note = notes[index];
                          final pastelColor =
                              pastelColors[index % pastelColors.length];
                          return Container(
                            color: pastelColor,
                            child: ListTile(
                              title: Text(note['teksti']),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteNote(note.id),
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
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
