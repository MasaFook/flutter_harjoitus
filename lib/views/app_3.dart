import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'dart:math';

class Shaker extends StatefulWidget {
  const Shaker({super.key});

  @override
  ShakerState createState() => ShakerState();
}

class ShakerState extends State<Shaker> {
  late ShakeDetector _shakeDetector;
  Color _backgroundColor = const Color.fromARGB(255, 100, 130, 145);

  @override
  void initState() {
    super.initState();
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: () {
        setState(() {
          _backgroundColor = _randomColor();
        });
      },
    );
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    super.dispose();
  }

  // Generate a random color
  Color _randomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shake Detector'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        color: _backgroundColor,
        child: const Center(
          child: Text(
            "Shake the phone to change the background color",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
