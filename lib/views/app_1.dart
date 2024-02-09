import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';


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
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
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
      floatingActionButton: FloatingActionButton(
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
      return Scaffold(
        appBar: AppBar(title: const Text('Display the Picture')),
        body: Image.file(File(imagePath)),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Check if the storage permission is granted
            var status = await Permission.storage.status;
            if (!status.isGranted) {
              // If not granted, request the storage permission
              status = await Permission.storage.request();
              if (!status.isGranted) {
                // Permission denied by the user
                scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Permission denied')));
                return;
              }
            }
            // Permission is granted, proceed with saving the image
            try {
              // Save the image to the device's gallery.
              await ImageGallerySaver.saveFile(imagePath);
              // Show a success message
              scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Image saved successfully')));
            } catch (e) {
              // Display an error message if the saving process fails.
              scaffoldMessenger.showSnackBar(SnackBar(content: Text('Failed to save image: $e')));
            }
          },
        child: const Icon(Icons.save_alt),
      ),
    );
  }
}