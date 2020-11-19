import 'dart:async';
import 'dart:developer';
import 'package:truelink/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:truelink/animation/pulsar.dart';
import 'package:truelink/internalnotification_subscription.dart';

class ProductCheckPage extends StatefulWidget {
  ProductCheckPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ProductCheckPageState createState() => _ProductCheckPageState();
}

class _ProductCheckPageState extends State<ProductCheckPage> {
  //int _counter = 0;
  // _stream is a subscription to the stream returned by `NFC.read()`.
  // The subscription is stored in state so the stream can be canceled later
  StreamSubscription<NDEFMessage> _streamReading;
  // _tags is a list of scanned tags
  NDEFMessage _tag;
  //bool _supportsNFC = false;

  // _readNFC() calls `NFC.readNDEF()` and stores the subscription and scanned
  // tags in state
  void _readNFC(BuildContext context) {

    try {
      // ignore: cancel_subscriptions
      StreamSubscription<NDEFMessage> subscription = NFC.readNDEF().listen(
              (tag) {
            // On new tag, add it to state
            setState(() {
              _tag= tag;
              log(tag.id);


            });

              globals.internalPushNotificationProvider.notifyNewInternalPush(
                  InternalNotificationType.STOP_READING,
                  null
              );
              globals.internalPushNotificationProvider.notifyNewInternalPush(
                  (tag.id.compareTo("043F0D5A5A5784")==0)?
                  InternalNotificationType.VERIFIED_NOT_ORIGINAL_PRODUCT:
                  InternalNotificationType.VERIFIED_ORIGINAL_PRODUCT,
                  null
              );

            // ritardo il rilascio dello stream per non farlo intercettare da
            // altri lettori
            Future.delayed(Duration(milliseconds: 1000), () {
              _stopReading();
            });

          },
          // When the stream is done, remove the subscription from state
          onDone: () {
            setState(() {
              _streamReading = null;
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
              _streamReading = null;
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
        _streamReading = subscription;
      });
    } catch (err) {
      print("error: $err");
    }
  }

  // _stopReading() cancels the current reading stream
  void _stopReading() {

    _streamReading?.cancel();
    setState(() {
      _streamReading = null;
    });
  }

  @override
  void initState() {
    super.initState();
    NFC.isNDEFSupported.then((supported) {
      setState(() {
        //_supportsNFC = true;
      });
    });
    _readTrueLink();
  }

  @override
  void dispose() {
    super.dispose();
    _streamReading?.cancel();
  }


  void _readTrueLink() {
    setState(() {
      _tag=null;
      if (_streamReading == null) {
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
  Pulsar pul=Pulsar();

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
        child:
        Stack( children: [

          (_streamReading != null)?
          pul:

          (_tag!=null)?Column(
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
                _tag.id.toString().compareTo("043F0D5A5A5784")==0?"false":"originale",
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                _tag.payload!=null?_tag.payload.toString():"no payload",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ):Text("vuoto"),

        ],)

      ),

      floatingActionButton: (_streamReading != null)?null:FloatingActionButton(
        onPressed: _readTrueLink,
        tooltip: 'Increment',
        child: Icon(Icons.not_started),
      ), // This trailing comma makes auto-formatting nicer for build methods.


    );
  }
}
