import 'package:flutter/material.dart';

class App1 extends StatelessWidget{
  const App1({
    Key? key,
}): super(key: key);

 @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('App1')
        ));
  }
}