import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truelink/buttons/check_public_key_btn.dart';
import 'package:truelink/buttons/object_browser_btn.dart';
import 'package:truelink/buttons/trx_browser_btn.dart';
import 'package:truelink/globals.dart' as globals;
import 'package:truelink/localization/custom_localizations.dart';
import 'package:camera/camera.dart';
import 'package:truelink/screens/take_picture_sccreen.dart';
import 'package:truelink/screens/product_check_screen.dart';

import '../internalnotification_subscription.dart';

class HomeScreen extends StatefulWidget{
  @override
  HomeScreenState createState() =>HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
implements InternalNotificationListener{
  static final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    globals.internalPushNotificationProvider.subscribe(this);
    globals.setCheckIsFirstAccessFalse();
  }

  @override
  void dispose() {
    globals.internalPushNotificationProvider.unsubscribe(this);
    super.dispose();
  }

  static Future<void>  buttonTakePictureCheck (BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;
    Navigator.of(context).push(
      CupertinoPageRoute<void>(
          title: "", builder: (BuildContext context) => TakePictureScreen(camera: firstCamera)),
    );
  }


  static void buttonProductCheck(BuildContext context) {
    debugPrint(" faccio un push nel navigator");
    Navigator.of(context).push(
      CupertinoPageRoute<void>(
          title: "", builder: (BuildContext context) => ProductCheckPage(title:CustomLocalizations.of(context).chooserProductCheckMex)),
    );
  }

  final Image _bkgImg = new Image(
    image: new AssetImage("assets/truelink_logo.png"),
    fit: BoxFit.none,
    color: Colors.white70,
    colorBlendMode: BlendMode.dstOut,
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: null,
        body: Stack(alignment: AlignmentDirectional.topCenter, children: <Widget>[
          _bkgImg,

          Container(
            padding: const EdgeInsets.only(top: 0.0),
            child: ClipRect(
              child: Container(
                padding: const EdgeInsets.only(top: 75.0, bottom: 10.0),
                child: globals.isaTopTitleImage,
                height: 150.0,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.only(top: 350.0),
              child: Form(
                key: formKey,
                child:
                Column(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        key: Key('__chooseform_productcheckbtn__'),
                        onTap: () => buttonProductCheck(context),
                        child: Container(
                          width: 200.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                            Border.all(color: Colors.blueAccent, width: 2.0),
                            borderRadius: BorderRadius.circular(26 / 1.5),
                          ),
                          child: Center(
                            child: Text(CustomLocalizations.of(context).chooserProductCheckMex,
                                style: globals.isaTextStyleBoldBlueVeryBig),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        key: Key('__chooseform_picturekbtn__'),
                        onTap: () => buttonTakePictureCheck(context),
                        child: Container(
                          width: 200.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                            Border.all(color: Colors.blueAccent, width: 2.0),
                            borderRadius: BorderRadius.circular(26 / 1.5),
                          ),
                          child: Center(
                            child: Text(CustomLocalizations.of(context).chooserProductPictureMex,
                                style: globals.isaTextStyleBoldBlueVeryBig),
                          ),
                        ),
                      ),
                    ),

                    BtnCheckKey(),
                    ObjectBrowserButton(),
                    TrxBrowserButton()

                  ],
                ),
              ),
            ),
          )
        ]));
  }

  @override
  void onInternalNotification(InternalNotificationType type, Map<int, String> mex) {
    // TODO: implement onInternalNotification
    switch (type) {
      case InternalNotificationType.NEW_KEYPAIR:
        setState(() {

        });
        break;
      default:
    }

  }



}