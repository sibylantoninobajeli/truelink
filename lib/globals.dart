library insofoscuolapp.globals;
import 'package:flutter/material.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:truelink/internalnotification_subscription.dart';
import 'cfg_network_endpoint.dart';
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pointycastle/api.dart' as api;
import 'dart:async';
import 'package:truelink/oracle/rsa_pem.dart';
import 'package:truelink/oracle/crypto.dart';




const bool isRelease = bool.fromEnvironment("dart.vm.product");

///*******************************************************************************
///* DEBUG ONLY SETTINGS
///* */
const bool resetDeviceStoredUser = false; //

/// jump to login page avoiding the intro
const bool skipIntroPhase = false;

/// used for developing in OFFLINE MODE
const bool skipLoginPhase = false;

/// let application open using FAKE user object
const bool useFakePosition = true;


String languageCode;

//const String testEndPoint = "http://192.168.10.25:8000"; //for DEBUG mode
const String prodEndPoint = "https://infoscuolapp.appspot.com"; //for RELEASE



//const blockchainEndPointHost = "blockchain.eu-frankfurt-1.oci.oraclecloud.com";
const blockchainEndPointHost = "sibylfounder-sibylit-fra.blockchain.ocp.oraclecloud.com";


const objectEndPointHost = "objectstorage.eu-frankfurt-1.oraclecloud.com";
//                            sibylfounder-sibylit-fra.blockchain.ocp.oraclecloud.com:7443/restproxy/bcsgw/rest/v1/transaction/invocation


const tenancyId="ocid1.tenancy.oc1..aaaaaaaaim3faii6ffmkujfczxiz6e4ezw5ogmj4ftqwosi7tyw4fstdkitq";
const authUserId="ocid1.user.oc1..aaaaaaaaxofkollklmasvqzvycdjw5wpx47dlk3kfqz2n63ygrpdby3dysdq";





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



final prefs = SharedPreferences.getInstance();

Future<String> getFingerprint() async {
  // obtain shared preferences
  try {
    String fingerprint=(await prefs).getString('fingerprint');
    localLog("found","fingerprint:"+fingerprint);
    return fingerprint;
  }catch(e){
    return null;
  }
}


RSAPublicKey rsaPublicKey;
RSAPrivateKey rsaPrivateKey;

getPublicRsaKeys() async {
  // obtain shared preferences
  try {
    String pubKeyPem=(await prefs).getString('public_key');
    rsaPublicKey=RsaKeyHelper().parsePublicKeyFromPem(pubKeyPem);

    localLog("loaded","public_key len"+pubKeyPem.length.toString()+" :"+pubKeyPem);
    return rsaPublicKey;
  }catch(e){
    return null;
  }
}


getPrivateRsaKeys() async {
  // obtain shared preferences
  try {
    String priKeyPem=(await prefs).getString('private_key');
    rsaPrivateKey=RsaKeyHelper().parsePrivateKeyFromPem(priKeyPem);

    localLog("loaded","private_key len"+priKeyPem.length.toString()+" :"+priKeyPem);
    return rsaPrivateKey;
  }catch(e){
    return null;
  }
}



saveRsaKeys(api.AsymmetricKeyPair pair) async {
  //rsaPrivateKey=pair.privateKey;
  //rsaPublicKey=pair.publicKey;
  String publicPem = encodePublicKeyToPem(pair.publicKey);
  String privatePem = encodePrivateKeyToPem(pair.privateKey);
  // obtain shared preferences
  try {
    (await prefs).setString('public_key',publicPem);
    localLog("saved","public_key len"+publicPem.length.toString()+" :"+publicPem);
    (await prefs).setString('private_key',privatePem);
    localLog("saved","private_key len"+privatePem.length.toString()+" :"+privatePem);
    //(await prefs).setString('fingerprint',fingerprint);

    getPublicRsaKeys();
    getPrivateRsaKeys();
    internalPushNotificationProvider.notifyNewInternalPush(InternalNotificationType.NEW_KEYPAIR, null);

    return true;
  }catch(e){
    return false;
  }
}


Future<bool> getCheckIsFirstAccess() async {
  // obtain shared preferences
  try {
    bool isFirstAccess=(await prefs).getBool('first_access');
    isFirstAccess=isFirstAccess!=null?isFirstAccess:true;
    localLog("loaded","isFirstAccess :"+isFirstAccess.toString());
    return isFirstAccess;
  }catch(e){
    return true;
  }
}


setCheckIsFirstAccessFalse() async {
  // obtain shared preferences
  try {
    (await prefs).setBool('first_access',false);
    localLog("loaded","isFirstAccess :FALSE");
  }catch(e){
  }
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