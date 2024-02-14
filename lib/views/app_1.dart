import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:device_info_plus/device_info_plus.dart';


// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
   final List<CameraDescription>? camera;
   const TakePictureScreen({this.camera, super.key});
  

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera! [0],
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            // You must wait until the controller is initialized before displaying the
            // camera preview. Use a FutureBuilder to display a loading spinner until the
            // controller has finished initializing. 
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  return CameraPreview(_controller);
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: const Color.fromARGB(162, 155, 39, 176),
                  // Provide an onPressed callback.
                  onPressed: () async {
                    // Take the Picture in a try / catch block. If anything goes wrong,
                    // catch the error.
                    try {
                      // Ensure that the camera is initialized.
                      await _initializeControllerFuture;
                      // Attempt to take a picture and get the file `image`
                      // where it was saved.
                      final image = await _controller.takePicture();
                      if (!mounted) return;
                      // If the picture was taken, display it on a new screen.
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(
                            // Pass the automatically generated path to
                            // the DisplayPictureScreen widget.
                            imagePath: image.path,
                          ),
                        ),
                      );
                    } catch (e) {
                      // If an error occurs, log the error to the console.
                      print(e);
                    }
                  },
                  child: const Icon(Icons.camera_alt),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

@override
Widget build(BuildContext context) {
  ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
  Size screenSize = MediaQuery.of(context).size;
  return Scaffold(
    appBar: AppBar(
      title: const Text('Displaying Picture'),
      backgroundColor: Theme.of(context).primaryColor,
    ),
    body: Stack(
      children: [
        Positioned.fill(
          child: Image.file(
            File(imagePath),
            width: screenSize.width,
            height: screenSize.height,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          bottom: 15,
          left: 0,
          right: 0,
          child: Center( // Align the TextButton to the center horizontally
            child: TextButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(162, 155, 39, 176)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Round up the button
                  ),
                ),
                foregroundColor: MaterialStateProperty.all(Colors.white), // Set text and icon color to white
              ),
              icon: const Icon(
                Icons.save_alt,
              ),
              label: const Text('Save'),
              onPressed: () async {
                // Check if the storage permission is granted
                final deviceInfo = await DeviceInfoPlugin().androidInfo;
                var status = await Permission.storage.status;
                // Check SDK
                if (deviceInfo.version.sdkInt < 32) {
                  if (!status.isGranted) {
                    // If not granted, request the storage permission
                    status = await Permission.storage.request();
                    if (!status.isGranted) {
                      // Permission denied by the user
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('Permission denied'),
                        ),
                      );
                      return;
                    }
                  }
                }
                // Permission is granted, proceed with saving the image
                try {
                  // Save the image to the device's gallery.
                  await ImageGallerySaver.saveFile(imagePath);
                  // Show a success message
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Image saved successfully'),
                    ),
                  );
                } catch (e) {
                  // Display an error message if the saving process fails.
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Failed to save image: $e'),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    ),
  );
}
}