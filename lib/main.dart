import 'package:flutter/material.dart';
import 'package:flutter_harjoitus/views/main_view.dart';
import 'package:email_validator/email_validator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.indigo, // Change to your desired accent color
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.purpleAccent),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/images/flutter-logo.png'),
              const SizedBox(height: 16), // Lisää väli, jos haluat
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Sähköpostiosoite on pakollinen';
                  }

                  // Tarkista, onko annettu merkkijono kelvollinen sähköpostiosoite
                  if (!EmailValidator.validate(value)) {
                    return 'Anna kelvollinen sähköpostiosoite';
                  }

                  // Jos kaikki on kunnossa, palauta null
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }

                  // Kaikki ehdot yhdessä lauseessa
                  if (!(value.length >= 8 &&
                      value.contains(RegExp(r'[A-Z]')) &&
                      value.contains(RegExp(r'[a-z]')) &&
                      value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) &&
                      value.contains(RegExp(r'[0-9]')))) {
                    return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one special character, and one digit';
                  }

                  // Jos kaikki on kunnossa, palauta null
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Validation passed, you can handle login logic here
                    // For simplicity, let's navigate to the MainView
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MainView()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child:
                    const Text('Login', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
