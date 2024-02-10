import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_view.dart';

class Muistilaput extends StatelessWidget {
  const Muistilaput({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Muistilaput',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _noteController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  String _getCurrentUserEmail() {
    if (_user != null) {
      return _user!.email ?? 'N/A';
    } else {
      return 'Not logged in';
    }
  }

  // Lisää apufunktio sähköpostin käyttäjänimen erottamiseen
  String getEmailUsername(String email) {
    // Tässä voit toteuttaa oman logiikkasi sähköpostiosoitteen pilkkomiseksi haluttuun muotoon
    // Esimerkiksi voit ottaa kaiken ennen @-merkkiä
    return email.split('@')[0];
  }

  String generateUserName(String email) {
    return email.split('@')[0];
  }

  String generateUsernameFromEmail(String email) {
    // Tässä otetaan kaikki ennen '@'-merkkiä oleva osa sähköpostiosoitteesta
    return email.split('@')[0];
  }

  void _signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        print('Kirjautunut käyttäjä UID: ${user.uid}');
        print('Käyttäjän nimi: ${user.displayName}');

        // Määritä käyttäjänimi sähköpostiosoitteen perusteella
        String userName = generateUserName(email);

        // Päivitä käyttäjänimi tähän
        await user.updateDisplayName(userName);

        // Odota hetki ennen kuin jatketaan
        await Future.delayed(Duration(seconds: 1));

        // Tässä vaiheessa käyttäjänimi on päivitetty Firebase Authenticationiin,
        // ja sen pitäisi olla saatavilla myös Firestoreen tallentamiseen.

        // Voit kutsua tässä _addNote-funktiota tai muita funktioita, joissa käyttäjänimeä käytetään.
      } else {
        print('Käyttäjäobjekti on null');
      }
    } catch (e) {
      print('Kirjautuminen epäonnistui: $e');
    }
  }

  String generateUniqueUserName() {
    String baseName = _user!.email?.split('@')[0] ?? 'user';
    return '$baseName${DateTime.now().millisecondsSinceEpoch}';
  }

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

  void _addNote() async {
    String noteText = _noteController.text.trim();
    if (noteText.isNotEmpty && _user != null) {
      try {
        // Päivitä käyttäjänimi sähköpostiosoitteen perusteella
        String userName = generateUsernameFromEmail(_user!.email!);

        // Päivitä käyttäjänimi Firebase Authenticationiin
        await _user!.updateDisplayName(userName);

        // Tallenna muistiinpano Firestoreen
        _firestore.collection('muistilaput').add({
          'teksti': noteText,
          'userId': _user!.uid,
          'userName': userName, // Käytä tässä _user!.displayName
          'timestamp': FieldValue.serverTimestamp(),
        });

        _noteController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Muistilapun lisäys onnistui'),
            duration: const Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print('Virhe muistiinpanon lisäyksessä: $e');
      }
    }
  }

  void _deleteNote(String noteId) {
    _firestore.collection('muistilaput').doc(noteId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Muistilapun poistaminen onnistui'),
        duration: const Duration(seconds: 2),
      ),
    );
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
                          return Container(
                            color: pastelColor,
                            child: ListTile(
                              title: Text(note['teksti']),
                              subtitle: Text(
                                  'Tekijä: ${note['userName'] ?? 'N/A'}'), // Käytä note['userName']
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
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
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
