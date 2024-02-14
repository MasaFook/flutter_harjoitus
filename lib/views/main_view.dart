import 'package:camera/camera.dart';
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
        actions:[
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
              colors: [Color.fromARGB(255, 100, 130, 145), Colors.white]
            ),
          ),
          child: Column(
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
                    ]
                  ),
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
                    ]
                  ),
                ]
          )
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
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
                      child: Column(
                        children: [
                          Text('Tekijät:',style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('Sami',style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('Henri',style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('Matti',style: TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      ),
                    );
                  },
                );
              },
            )
          ]
        ),
      )
    );
  }
}
