import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:truelink/globals.dart' as globals;
import 'package:truelink/localization/custom_localizations.dart';

import 'package:truelink/screens/key_generator.dart';

import '../globals.dart';

class BtnCheckKey extends StatefulWidget {
  BtnCheckKey();
  @override
  _BtnCheckKey createState() => _BtnCheckKey();
}

class _BtnCheckKey extends State<BtnCheckKey> {
  bool publicKeyPresent = false;

  String fingerPrint;
  @override
  initState()  {
    super.initState();

    globals.getFingerprint().then((value) => {
      fingerPrint=value
    });

    globals.getPublicKey().then((value) => {
          setState(() {
            if (value!=null) {
              publicKeyPresent =true;
            }else{

            }
          })
        });
  }

  static Future<void> buttonStoredObject(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    Navigator.of(context).push(
      CupertinoPageRoute<void>(
          title: "", builder: (BuildContext context) => StoredObjectsScreen()),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        key: Key('__chooseform_ketgenbtn__'),
        onTap: () => buttonStoredObject(context),
        child: Container(
          width: 200.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueAccent, width: 2.0),
            borderRadius: BorderRadius.circular(26 / 1.5),
          ),
          child: Center(
            child: Text(
                publicKeyPresent
                    ? CustomLocalizations.of(context).chooserRegenMex+" "+fingerPrint
                    : CustomLocalizations.of(context).chooserKeyGenMex,
                style: globals.isaTextStyleBoldBlueVeryBig),
          ),
        ),
      ),
    );
  }
}
