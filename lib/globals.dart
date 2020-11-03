library insofoscuolapp.globals;
import 'package:flutter/material.dart';
import 'package:truelink/internalpushnotification_subscription.dart';
import 'cfg_network_endpoint.dart';
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

const bool isRelease = bool.fromEnvironment("dart.vm.product");

///*******************************************************************************
///* DEBUG ONLY SETTINGS
///* */
const bool resetDeviceStoredUser = true; //

/// jump to login page avoiding the intro
const bool skipIntroPhase = false;

/// used for developing in OFFLINE MODE
const bool skipLoginPhase = false;

/// let application open using FAKE user object
const bool useFakePosition = true;


String languageCode;

//const String testEndPoint = "http://192.168.10.25:8000"; //for DEBUG mode
const String prodEndPoint = "https://infoscuolapp.appspot.com"; //for RELEASE

const String testDevice = 'YOUR_DEVICE_ID';
final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
const bool isDev = !isRelease;

String getEndPoint(){
  return isDev
      ?testEndPoint
      :prodEndPoint;
}


const int minLoginCharNum = 2;


final circularProgressColor= grigioLigthpingColor;

final greenpingColor = const Color(0xff59bc6d);
final bluGoogleColor = const Color(0xff4d93f3);
final redNotifyColor = const Color(0xffad0000);
final redInternetStatus = const Color(0xe0dc5d62);
final redErrorColor = const Color(0xffce395f);
final blupingColor = const Color(0xff4768ad);
final violettepingColor = const Color(0xff645992);
final pinkpingColor = const Color(0xffD44083);
final blackpingColor = const Color(0xff272727);
final black2pingColor = const Color(0xffb3b3b3);
final grigiopingColor = const Color(0xff838383);

final grigioLigthpingColor = const Color(0xfff9f9f9);
final grigioSuperLigthColor = const Color(0xffc8c7cc);
final grigioAvanzamentoColor = const Color(0xffdcdde2);
final radareBordiInteracted = blupingColor;
final radareBordiNoInteracted = const Color(0xffdcdde2);


// IMAGEX COLORS EAND FONTS
final Image isaTopTitleImage =
Image.asset('assets/truelink_logo.png', fit: BoxFit.cover);

///**
/// * Official logger method
///* */
void localLog(String classname, String msg) {
  //print(classname + "::=" + msg);
  debugPrint(classname + "::=" + msg);
}


/*
* Special storages for first access and GEO permission requests
*
* */

Future<bool> clearPref() async {
  SharedPreferences prefsLoader = await SharedPreferences.getInstance();
  bool res = await prefsLoader.clear();
  if (res) {
    debugPrint(" clearPref!");
    return true;
  }
  return false;
}

TextStyle isaTextStyleBoldWhiteMedium = TextStyle(
    fontFamily: "Helvetica nueue bold", fontSize: 14.0, color: Colors.white);

TextStyle isaTextStyleBoldBlueSmall = TextStyle(
    fontFamily: "Helvetica nueue bold", fontSize: 9.0, color: blupingColor);

TextStyle isaTextStyleBoldBlackMedium = TextStyle(
    fontFamily: "Helvetica nueue bold", fontSize: 14.0, color: Colors.black);

TextStyle isaTextStyleBoldRedBig = TextStyle(
    fontFamily: "Helvetica nueue bold", fontSize: 16.0, color: Colors.red);

TextStyle isaTextStyleBoldBlueMedium = TextStyle(
    fontFamily: "Helvetica nueue bold", fontSize: 14.0, color: blupingColor);

TextStyle isaTextStyleBoldBlueVeryBig = TextStyle(
    fontFamily: "Helvetica nueue bold", fontSize: 18.0, color: blupingColor);


TextStyle isaTextStyleRegularWhiteBig = TextStyle(
    fontFamily: "Helvetica nueue regular",
    fontSize: 16.0,
    letterSpacing: 1.0,
    fontWeight: FontWeight.w900,
    color: Colors.white);

TextStyle isaTextStyleBoldBlackVeryBig = TextStyle(
    fontFamily: "Helvetica nueue bold",
    letterSpacing: 0.8,
    fontSize: 30.0,
    color: Colors.black);

TextStyle isaTextStyleRegularBlueSize2 = TextStyle(
    fontFamily: "Helvetica nueue regular",
    fontWeight: FontWeight.w900,
    letterSpacing: 0.8,
    fontSize: 14.0,
    color: blupingColor);



TextStyle isaTextStyleBoldWhiteBig = TextStyle(
    fontFamily: "Helvetica nueue bold", fontSize: 16.0, color: Colors.white);


InternalPushNotificationListenerProviderSingleton
internalPushNotificationProvider =
InternalPushNotificationListenerProviderSingleton.internal();