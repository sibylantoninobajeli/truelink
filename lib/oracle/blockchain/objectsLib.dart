import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart'; //for date format
import 'package:flutter/material.dart';
import 'package:truelink/oracle/rsa_pem.dart';
import 'package:truelink/models/stored_object.dart';
import 'package:truelink/oracle/crypto.dart';
import 'package:truelink/globals.dart' as globals;
import 'package:crypto/crypto.dart';
import 'package:truelink/screens/stored_object_viewer.dart';

class ObjectsAPI {
  static final tenancyId =
      "ocid1.tenancy.oc1..aaaaaaaaim3faii6ffmkujfczxiz6e4ezw5ogmj4ftqwosi7tyw4fstdkitq";
  static final authUserId =
      "ocid1.user.oc1..aaaaaaaaxofkollklmasvqzvycdjw5wpx47dlk3kfqz2n63ygrpdby3dysdq";

  static var keyFingerprint = "";
  static var keyId;
  static var _date = DateFormat('E, d MMM y H:m:s', 'en_US');
  //Sun, 15 Nov 2020 10:40:51 GMT

  static final method = "GET";
  static final targetPrefix = "/n/frhvjnni10jd/b/BlockChainSibylBucket/o/";

  static var uri;
  static final alg = "rsa-sha256";
  static final sigVersion = "1";
  static var headers = "(request-target) date host";
  static var sig;

  static var dateHeader, hostHeader, signingString = "";
  static String dateNow;
  static StoredObjects objectsFromServer;

  static String target = "";

  static String convertToFingerprintStringFormat(String str) {
    int numChunks = (str.length / 2).ceil();
    List<String> chunks = new List();
    for (int o = 0; o < numChunks * 2; o += 2) {
      chunks.add(str.substring(o, o + 2));
    }
    return chunks.join(':');
  }


  static String getCurrentPrivateKeyFingerprint(){
    List<int> derFromPublicKey =
    decodePEM(encodePublicKeyToPem(globals.rsaPublicKey));
    String compressedKeyFingerprint = md5.convert(derFromPublicKey).toString();
    return compressedKeyFingerprint;
  }






  static Future<void> buttonStoredObjectDetailAction(BuildContext context,String title) async {
    Navigator.of(context).push(
      CupertinoPageRoute<void>(
          title: title, builder: (BuildContext context) => StoredObjectViewScreen(title,title: title)),
    );
  }
  static Future<Widget> wrapActionButtonImage(BuildContext context,String objectName,double w, double h) async{
      Image img=await getPngImage( objectName,w,h);
    return   FlatButton(child:img,onPressed:() => buttonStoredObjectDetailAction(context,objectName));
  }


  static Future<Image> getPngImage(String objectName,double w, double h) async {

    keyFingerprint = getCurrentPrivateKeyFingerprint();
    keyFingerprint = convertToFingerprintStringFormat(keyFingerprint);

    globals.localLog("classname", "fingerprint:" + keyFingerprint);

    keyId = "$tenancyId/$authUserId/$keyFingerprint";
    dateNow = _date.format(DateTime.now().toUtc()) + " GMT";

    globals.localLog("classname", "Datenow: " + dateNow);

    dateHeader = "date: " + dateNow;
    hostHeader = "host: "+globals.objectEndPointHost;
    target = targetPrefix + objectName;
    final requestTarget =
        "(request-target): " + method.toLowerCase() + " " + target;
    globals.localLog("classname", "request target: " + requestTarget);

    signingString = "$requestTarget\n$dateHeader\n$hostHeader";

    sig = sign(
        Uint8List.fromList(signingString.codeUnits), globals.rsaPrivateKey);

    uri = Uri.parse("https://" + globals.objectEndPointHost + target);

    String authStr =
        "Signature version=\"$sigVersion\",keyId=\"$keyId\",algorithm=\"$alg\",headers=\"$headers\",signature=\"$sig\"";
    Map<String, String> reqheaders = {
      "date": dateNow,
      "host": globals.objectEndPointHost,
      "Authorization": authStr
    };
    globals.localLog("storage call uri", uri.toString());
    globals.localLog("storage call aut", authStr.toString());

    globals.localLog("storage","^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
    globals.localLog("storage call aut", ""+reqheaders.toString());

    /*globals.localLog("storage","^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
    globals.localLog("storage call aut", ""+_headers.toString());*/

    //await http.get(uri, headers: reqheaders).then((response){
    //var response = await http.get(uri,headers: reqheaders);
    return Image.network(
        uri.toString(),
        width: 300,
        headers: reqheaders,
        scale: 0.5,
      );


  }
}
