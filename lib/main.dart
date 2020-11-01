import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  // _stream is a subscription to the stream returned by `NFC.read()`.
  // The subscription is stored in state so the stream can be canceled later
  StreamSubscription<NDEFMessage> _stream;

  // _tags is a list of scanned tags
  NDEFMessage _tag = null;

  bool _supportsNFC = false;

  bool _isReading =false;

  // _readNFC() calls `NFC.readNDEF()` and stores the subscription and scanned
  // tags in state
  void _readNFC(BuildContext context) {
    setState(() {
      _isReading=true;
    });
    try {
      // ignore: cancel_subscriptions
      StreamSubscription<NDEFMessage> subscription = NFC.readNDEF().listen(
              (tag) {
            // On new tag, add it to state
            setState(() {
              _tag= tag;
              log(tag.id);
            });
          },
          // When the stream is done, remove the subscription from state
          onDone: () {
            setState(() {
              _stream = null;
            });
          },
          // Errors are unlikely to happen on Android unless the NFC tags are
          // poorly formatted or removed too soon, however on iOS at least one
          // error is likely to happen. NFCUserCanceledSessionException will
          // always happen unless you call readNDEF() with the `throwOnUserCancel`
          // argument set to false.
          // NFCSessionTimeoutException will be thrown if the session timer exceeds
          // 60 seconds (iOS only).
          // And then there are of course errors for unexpected stuff. Good fun!
          onError: (e) {
            setState(() {
              _stream = null;
            });

            if (!(e is NFCUserCanceledSessionException)) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Error!"),
                  content: Text(e.toString()),
                ),
              );
            }
          });

      setState(() {
        _stream = subscription;
      });
    } catch (err) {
      print("error: $err");
    }
  }

  // _stopReading() cancels the current reading stream
  void _stopReading() {
    _stream?.cancel();
    setState(() {
      _isReading=false;
      _stream = null;
    });
  }

  @override
  void initState() {
    super.initState();
    NFC.isNDEFSupported.then((supported) {
      setState(() {
        _supportsNFC = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stream?.cancel();
  }


  void _readTrueLink() {
    setState(() {
      _tag=null;
      if (_stream == null) {
        _readNFC(context);
      } else {
        _stopReading();
      }

      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:

      Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: (_tag!=null)?Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text(_tag.data!=null?_tag.data.toString():"no data",
            ),
            Text(
              _tag.id.toString().compareTo("043F0D5A5A5784")==0?"vero":"Falso",
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              _tag.payload!=null?_tag.payload.toString():"no payload",
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ):Text("vuoto"),
      ),
      floatingActionButton: _isReading?null:FloatingActionButton(
        onPressed: _readTrueLink,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
