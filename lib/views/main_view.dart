import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_harjoitus/views/app_1.dart';
import 'package:flutter_harjoitus/views/app_2.dart';
import 'package:flutter_harjoitus/views/app_3.dart';

class MainView extends StatelessWidget {
  const MainView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Harkka-appi'),
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  icon: const Icon(Icons.person)),
            ]),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(255, 100, 130, 145), Colors.white]),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined),
                  iconSize: 48.0,
                  color: const Color(0xFF000000),
                  onPressed: () async {
                    WidgetsFlutterBinding.ensureInitialized();
                    await availableCameras().then((value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TakePictureScreen(camera: value))));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.note_alt_outlined),
                  iconSize: 48.0,
                  color: const Color(0xFF000000),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyHomePage()));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.autorenew),
                  iconSize: 48.0,
                  color: const Color(0xFF000000),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Shaker()));
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          height: 70,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_drop_up_outlined),
              iconSize: 48.0,
              color: const Color(0xFF000000),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color.fromARGB(255, 185, 191, 207),
                  builder: (context) {
                    return const SizedBox(
                      height: 130,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              'Tekijät:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Sami: Firebase, muistilaput',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Henri: Shaker, UI',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Matti: Kamera, UI',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          ]),
        ));
  }
}
