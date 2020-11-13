import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:crypto/crypto.dart';

/*
usefull function for hashing
 */

generateImageHash(File file) async{
  var imageBytes =  file.readAsBytesSync().toString();
  var bytes = utf8.encode(imageBytes.toString()); // data being hashed
  String digest = sha256.convert(bytes).toString();
  print("This is image Digest :  $digest");
  return digest;
}


// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
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
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SendPictureScreen(imagePath: imagePath),
              ),
            );

          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}


class SendPictureScreen extends StatefulWidget {

  final String imagePath;

  const SendPictureScreen({
    Key key,
    @required this.imagePath,
  }) : super(key: key);

  @override
  SendPictureScreenState createState() => SendPictureScreenState();

}



// A widget that displays the picture taken by the user.
class SendPictureScreenState extends State<SendPictureScreen> {

  bool sending=false;
  String message="";

  @override
  void initState() {
    message=widget.imagePath+"  ";
    super.initState();
    // other stufs
    setState(() {
      sending=true;
    });
    sendPicture();
  }


  sendPicture() async {
    try {
      var uri = Uri.parse(
          'https://objectstorage.eu-frankfurt-1.oraclecloud.com/p/BnloPp9BMEKWt_S7g-2GoOTKB6HB4om-_GPQvXGnLEFGm1FDdZyInFEwpKaH2ami/n/frhvjnni10jd/b/BlockChainSibylBucket/o/bitcoin-3163494__340.png');
/*      var request = http.MultipartRequest('PUT', uri)
      //..fields['user'] = 'nweiz@google.com'
        ..files.add(await http.MultipartFile.fromPath(
            '', widget.imagePath,
            contentType: MediaType('image/png','')
        ));*/



      var request = http.MultipartRequest(
        'PUT', uri,
      );

      /*Map<String,String> headers={
        "Authorization":"Bearer $token",
        "Content-type": "multipart/form-data"
      };*/
      File file= new File( widget.imagePath);
      request.files.add(
        http.MultipartFile(
          'file',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          //filename: filename,
          contentType: MediaType('image','png'),
        ),
      );
      /*request.headers.addAll(headers);
      request.fields.addAll({
        "name":"test",
        "email":"test@gmail.com",
        "id":"12345"
      });
*/




      var imageHash = await compute(generateImageHash,file );

      message += " HASH:"+imageHash+"   ";

      List<int> fileByte= file.readAsBytesSync();
      Map<String,String> headers={
        "User-Agent":" curl1/7",
        "Content-Length":" "+fileByte.length.toString(),

      };

      var response = await http.put(uri,headers: headers,body: fileByte);

      //var response = await request.send();


      if (response.statusCode == 200) {
        print('Uploaded!');
        message +='Uploaded';
      }else {
        print('Error');
        print(response.statusCode);
        message+=response.statusCode.toString();
      }
      setState(() {
        sending = false;
      });
    }catch(e){
      print(e);
      message+=e.toString();
      setState(() {
        sending = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: sending?CircularProgressIndicator(backgroundColor: Colors.blue,strokeWidth: 4.0,):Container(child:Text(message))

    );
  }
}