import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_harjoitus/views/main_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> _signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'testi1@gmail.com',
        password: 'testi1',
      );

      User? user = userCredential.user;
      if (user != null) {
        print('Kirjautunut käyttäjä UID: ${user.uid}');
        print('Käyttäjän nimi: ${user.displayName}');
      }
    } catch (e) {
      print('Kirjautuminen epäonnistui: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];

    const String appTitle = 'Flutter layout demo';
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.pinkAccent),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/main-view',
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            providers: providers,
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) async {
                await _signIn(); // Kutsu _signIn-funktiota kirjautumisen yhteydessä
                Navigator.pushReplacementNamed(context, '/main-view');
              }),
            ],
          );
        },
        '/profile': (context) {
          return ProfileScreen(
            providers: providers,
            actions: [
              SignedOutAction((context) {
                Navigator.pushReplacementNamed(context, '/sign-in');
              }),
            ],
          );
        },
        '/main-view': (context) {
          return const MainView();
        }
      },
    );
  }
}
