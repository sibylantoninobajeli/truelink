import 'dart:typed_data';
import 'package:intl/intl.dart'; //for date format
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:truelink/oracle/blockchain/rsa_pem.dart';
import 'package:truelink/models/stored_object.dart';
import 'package:truelink/oracle/blockchain/crypto.dart';
import 'package:truelink/globals.dart' as globals;
import 'package:crypto/crypto.dart';

class ObjectsAPI {
  static final tenancyId =
      "ocid1.tenancy.oc1..aaaaaaaaim3faii6ffmkujfczxiz6e4ezw5ogmj4ftqwosi7tyw4fstdkitq";
  static final authUserId =
      "ocid1.user.oc1..aaaaaaaaxofkollklmasvqzvycdjw5wpx47dlk3kfqz2n63ygrpdby3dysdq";

  static var keyFingerprint = "";
  static var keyId;
  static var _date = DateFormat('E, d MMM y H:m:s', 'en_US');
  //Sun, 15 Nov 2020 10:40:51 GMT

  static final host = "objectstorage.eu-frankfurt-1.oraclecloud.com";
  static final method = "GET";
  static final target_prefix = "/n/frhvjnni10jd/b/BlockChainSibylBucket/o/";

  static var uri;
  static final alg = "rsa-sha256";
  static final sigVersion = "1";
  static var headers = "(request-target) date host";
  static var sig;

  static var date_header, host_header, signing_string = "";
  static String datenow;
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

  static Future<Image> getPngImage(String objectName) async {
    List<int> derFromPublicKey =
        decodePEM(encodePublicKeyToPem(globals.rsaPublicKey));
    String compressedKeyFingerprint = md5.convert(derFromPublicKey).toString();
    keyFingerprint = convertToFingerprintStringFormat(compressedKeyFingerprint);
    globals.localLog("classname", "fingerprint:" + keyFingerprint);

    keyId = "$tenancyId/$authUserId/$keyFingerprint";
    datenow = _date.format(DateTime.now().toUtc()) + " GMT";
    globals.localLog("classname", "Datenow: " + datenow);

    date_header = "date: " + datenow;
    host_header = "host: $host";
    target = target_prefix + objectName;
    final request_target =
        "(request-target): " + method.toLowerCase() + " " + target;
    globals.localLog("classname", "request target: " + request_target);

    signing_string = "$request_target\n$date_header\n$host_header";
    //signing_string="(request-target): get /n/frhvjnni10jd/b/BlockChainSibylBucket/o?compartmentId=ocid1.compartment.oc1..aaaaaaaawoc74tyx4r4iksbgffs37vv7h2okwbi55wmsn53sv6rjxwh5b4qq\ndate: Sun, 15 Nov 2020 21:47:14 GMT\nhost: objectstorage.eu-frankfurt-1.oraclecloud.com";

    sig = sign(
        Uint8List.fromList(signing_string.codeUnits), globals.rsaPrivateKey);

    //sig = "iro/BGeKEwX4miFoHRXqIVNPLUnvulwnTMZozhikz8X9IRJ4FoodZTCy/1SvEvJdhfR97Q23KEsEoxhQGfn2MYFS8UnIVkiZ9tl5dq+GlxbjFRGfT8q75Vc/Aciqvj1/nyazAKME8d8fcWz8OlYPXrTgiemKCgwK2WTihlf/6ungburfuB1E3jL5jFXqEwO2BUamfm6+EzDudj6a1QRxtYg5zvllNr+9gQUathlXlmbIhDsU753DoxC4BnLtAIiHcoyGbhcpj+k8cu1cn1KyGc8AXN9hQvxDqDRzWcpMsAA/uUOlM2+6aQP8kuC2bJm9PDiqbog+vhZLNV9aaks1EQ==";
    uri = Uri.parse("https://" + host + target);

    String authStr =
        "Signature version=\"$sigVersion\",keyId=\"$keyId\",algorithm=\"$alg\",headers=\"$headers\",signature=\"$sig\"";
    Map<String, String> reqheaders = {
      "date": datenow,
      "host": host,
      "Authorization": authStr
    };
    globals.localLog("storage call uri", uri.toString());
    globals.localLog("storage call aut", authStr.toString());
    await http.get(uri, headers: reqheaders).then((response){
      return Image.network(
        uri.toString(),
        width: 300.0,
        headers: reqheaders,
        scale: 0.5,
      );
    });

  }
}
