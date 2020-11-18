import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:truelink/globals.dart' as globals;
//import 'package:truelink/localization/custom_localizations.dart';
//import 'package:truelink/models/isatutenze.dart';
//import 'dart:ui';
//import 'login_screen.dart';
//import 'package:truelink/models/user.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';

//FirebaseAnalytics analytics = FirebaseAnalytics();

bool isGoogleEmail=false;
//Isatutenze registrationIsatutente;

class RegistrationScreen1MailSwitch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RegistrationScreen1MailSwitchState();
  }
}

class RegistrationScreen1MailSwitchState
    extends State<RegistrationScreen1MailSwitch> {

  static void goToMailSection(BuildContext context,
      {bool verifiedByGoogle = false}) {
    /*
    switch (verifiedByGoogle) {
      case false:
        Navigator.of(context).push(
          CupertinoPageRoute<void>(
              title: "",
              builder: (BuildContext context) =>
                  RegistrationScreen2MailOther()),
        );
        break;
      case true:
        Navigator.of(context).push(
          CupertinoPageRoute<void>(
              title: "",
              builder: (BuildContext context) =>
                  RegistrationScreen2MailSGoogle()),
        );
        break;
    }*/
  }

  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(

      navigationBar: CupertinoNavigationBar(
        middle: globals.isaTopTitleImage,

      ),
      child: SafeArea(

        top: false,
        bottom: false,
        child:
        Padding(padding: EdgeInsets.only(top:60.0),
        child:
        Card(

          child: Column(

            children: <Widget>[
              SizedBox(
                height: 6.0,
                child: LinearProgressIndicator(
                    value: 0.25,

                    backgroundColor: globals.grigioAvanzamentoColor),
              ),
              Expanded(
                child: Container(),
              ),

              /*
              /// TITOLO
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(CustomLocalizations.of(context).regCreateAccountMex,
                    style: globals.isaTextStyleBoldBlackVeryBig),
              ),
*/


              /*
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  key: Key('__chooseform_emailgooglebtn__'),
                  onTap: () =>
                      goToMailSection(context, verifiedByGoogle: true),
                  child: Container(
                    width: 300.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: globals.bluGoogleColor,
                      borderRadius: BorderRadius.circular(50 / 1.5),
                    ),
                    child: Center(
                      child: Text(
                          CustomLocalizations.of(context)
                              .regEmailGoogleBtnLabel,
                          textAlign: TextAlign.justify,
                          style: globals.isaTextStyleBoldWhiteBig),
                    ),
                  ),
                ),
              ),
*/
              Expanded(
                child: Container(),
              ),


              /// Sezione rimandoa hai già un account

              Divider(
                color: globals.grigioSuperLigthColor,
                height: 3.0,
              ),


              /*
              Container(
                height: 60.0,
                alignment: Alignment.topLeft,
                color: globals.grigioLigthpingColor,
                child: Padding(
                    padding: EdgeInsets.only(top: 5.0, left: 5.0),
                    child: InkWell(
                      key: Key('__registrationform_changepwd2__'),
                      onTap: () {
                        Navigator.of(context).pop(true);
                        Navigator.of(context).push(
                          CupertinoPageRoute<void>(
                              title: "",
                              builder: (BuildContext context) =>
                                  LoginScreenNew()),
                        );
                      },
                      child: Text(CustomLocalizations.of(context).regHaveAccountLabel,
                          style: globals.isaTextStyleRegularBlueSize2),
                    )),
              ),*/
            ],
          ),
        ),
        ),
      ),
    );
  }
}
