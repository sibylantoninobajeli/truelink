import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:truelink/globals.dart' as globals;
import 'package:truelink/localization/custom_localizations.dart';

import 'package:truelink/screens/key_generator.dart';
import 'package:truelink/screens/stored_object_browser.dart';

class ObjectBrowserButton extends StatefulWidget {
  @override
  _ObjectBrowserButton createState() => _ObjectBrowserButton();
}

class _ObjectBrowserButton extends State<ObjectBrowserButton> {
  bool publicKeyPresent = false;

  String fingerPrint;

  @override
  initState()  {
    super.initState();
  }

  static Future<void> buttonStoredObjectAction(BuildContext context) async {
    Navigator.of(context).push(
      CupertinoPageRoute<void>(
          title: "", builder: (BuildContext context) => StoredObjectsScreen(title:CustomLocalizations.of(context).chooserObjectBrowser)),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        key: Key('__chooseform_ketgenbtn__'),
        onTap: () => buttonStoredObjectAction(context),
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
                 CustomLocalizations.of(context).chooserObjectBrowser,
                style: globals.isaTextStyleBoldBlueVeryBig),
          ),
        ),
      ),
    );
  }
}
