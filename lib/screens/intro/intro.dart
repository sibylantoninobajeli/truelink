import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:truelink/buttons/check_public_key_btn.dart';
import 'package:truelink/buttons/object_browser_btn.dart';
import 'package:truelink/globals.dart' as globals;
import 'dart:ui';
import 'package:truelink/localization/custom_localizations.dart';
import 'package:truelink/screens/auth/login_screen.dart';
import 'package:truelink/screens/auth/regstr_scr1_mail_switch.dart';
import 'package:flutter/services.dart';
import 'package:truelink/screens/key_generator.dart';
import 'package:truelink/screens/product_check.dart';
import 'page_selector.dart';
import 'package:truelink/screens/take_picture.dart';

/// A widget connecting its life cycle to a [VideoPlayerController] using
/// an asset as data source
///
///
///
/// // // //
///
///
///






/// // // //







class Intro extends StatelessWidget {
  final String routeName = '/material/page-selector';


  Widget textContainer(Key key,String text){
    return
      Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 70.0, left: 20.0, right: 20.0),
          child: Container(
              padding: EdgeInsets.all(10.0),
              decoration:new BoxDecoration(
                color: const Color(0x88999999),
                borderRadius: new BorderRadius.all(const  Radius.circular(40.0), ),
              ),
              child: Text(text,
                  textAlign: TextAlign.center,
                  //style: Style(),
                  textScaleFactor: 1.0,
                  style: globals.isaTextStyleRegularWhiteBig),
              key: key),
        ),
      );

  }


  static void buttonLogin(BuildContext context) {
    // nuovo login

    debugPrint(" faccio un push nel navigator");
    Navigator.of(context).push(
      CupertinoPageRoute<void>(
          title: "", builder: (BuildContext context) => LoginScreenNew()),
    );

    //
    // Vecchio login
    // Navigator.of(context).pushNamed('/login');
  }

  static void buttonProductCheck(BuildContext context) {
    debugPrint(" faccio un push nel navigator");
    Navigator.of(context).push(
      CupertinoPageRoute<void>(
          title: "", builder: (BuildContext context) => ProductCheckPage(title:CustomLocalizations.of(context).chooserProductCheckMex)),
    );


    //
    // Vecchio login
    // Navigator.of(context).pushNamed('/login');
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


    //
    // Vecchio login
    // Navigator.of(context).pushNamed('/login');
  }




  static void buttonRegistration(BuildContext context) {
    // nuovo login

    Navigator.of(context).push(
      CupertinoPageRoute<void>(
          title: "",
          //builder: (BuildContext context) => RegistrationScreenNew()),
          builder: (BuildContext context) => RegistrationScreen1MailSwitch()),
    );
    // vecchio login
    //Navigator.of(context).pushNamed('/registration');
  }

  static final formKey = GlobalKey<FormState>();

  bool publicKeyPresent=false;

  final Image _bkgImg = new Image(
    image: new AssetImage("assets/truelink_logo.png"),
    fit: BoxFit.none,
    color: Colors.white70,
    colorBlendMode: BlendMode.dstOut,
  );



  @override
  Widget build(BuildContext context) {

    final List<Widget> widgetPages = <Widget>[
      Stack(children: <Widget>[
        _bkgImg,

        textContainer(Key('__testo_pres_1__'),CustomLocalizations.of(context).tutorial1Mex1)
      ]),
      Stack(children: <Widget>[
        _bkgImg,
        textContainer(Key('__testo_pres_2__'),CustomLocalizations.of(context).tutorial1Mex2)

      ]),
      Stack(children: <Widget>[
        _bkgImg,
        textContainer(Key('__testo_pres_3__'),CustomLocalizations.of(context).tutorial1Mex3)

      ]),

/*
//registration/login
      Scaffold(
          appBar: null,
          body: Stack(alignment: AlignmentDirectional.topCenter, children: <Widget>[
            _bkgImg,

            Container(
              //color:Colors.blue,
              padding: const EdgeInsets.only(top: 0.0),
              child: ClipRect(
                child: Container(
                  //color:Colors.redAccent,
                  padding: const EdgeInsets.only(top: 75.0, bottom: 10.0),
                  child: globals.isaTopTitleImage,
                  height: 150.0,
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.only(top: 450.0),
                child: Form(
                  key: formKey,
                  child:
                  Column(
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          key: Key('__chooseform_loginbtn__'),
                          onTap: () => buttonLogin(context),
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
                              child: Text(CustomLocalizations.of(context).chooserLoginMex,
                                  style: globals.isaTextStyleBoldBlueVeryBig),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          key: Key('__chooseform_registerbtn__'),
                          onTap: () => buttonRegistration(context),
                          child: Container(
                            width: 200.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border:
                                  Border.all(color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(26 / 1.5),
                            ),
                            child: Center(
                              child: Text(CustomLocalizations.of(context).chooserRegisterMex,
                                  style: globals.isaTextStyleBoldRedBig),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ])),
*/
      Scaffold(
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
                padding: const EdgeInsets.only(top: 450.0),
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
                   ObjectBrowserButton()

                    ],
                  ),
                ),
              ),
            )
          ])),
    ];

    return Theme(
        data: ThemeData(
          primarySwatch: Colors.red, // e' un colore del material design
          brightness: Brightness.light,

          /// canvans di base chiara
          ///
          primaryColor: globals.blupingColor,
          accentColor: Colors.white,
        ),
        child: Scaffold(
          // backgroundColor:Colors.white,
          appBar: null, // AppBar(title: const Text('Page selector')),
          body: DefaultTabController(
            length: widgetPages.length,
            child: PageSelectorStfl(widgetPages: widgetPages),
          ),
        ));
  }
}
