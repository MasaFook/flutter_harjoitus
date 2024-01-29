import 'package:flutter/material.dart';
import 'package:flutter_harjoitus/views/app_1.dart';
import 'package:flutter_harjoitus/views/app_2.dart';
import 'package:flutter_harjoitus/views/app_3.dart';
import 'package:flutter_harjoitus/views/app_4.dart';
import 'package:flutter_harjoitus/views/app_5.dart';
import 'package:flutter_harjoitus/views/app_6.dart';

class MainView extends StatelessWidget {
  const MainView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Name'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.filter_1),
                    iconSize: 48.0,
                    color: const Color(0xFF000000),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const App1()));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_2),
                    iconSize: 48.0,
                    color: const Color.fromARGB(255, 243, 5, 5),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const App2()));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_3),
                    iconSize: 48.0,
                    color: const Color(0xFF000000),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const App3()));
                    },
                  )
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.filter_4),
                    iconSize: 48.0,
                    color: const Color(0xFF000000),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const App4()));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_5),
                    iconSize: 48.0,
                    color: const Color(0xFF000000),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const App5()));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_6),
                    iconSize: 48.0,
                    color: const Color(0xFF000000),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const App6()));
                    },
                  )
                ])
          ]),
    );
  }

  void iconButtonPressed() {}
}
