import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart'; //for date format
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:truelink/models/lotto_olive.dart';
import 'package:truelink/models/tx_response.dart';
import 'package:truelink/models/vehicle_part.dart';
import 'package:truelink/oracle/rsa_pem.dart';
import 'package:truelink/models/stored_object.dart';
import 'package:truelink/oracle/crypto.dart';
import 'package:truelink/globals.dart' as globals;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:truelink/oracle/stored_object/objectsLib.dart';
//import 'package:truelink/screens/stored_object_viewerLib.dart';

class TrxBrowserScreen extends StatefulWidget {
  final title;
  TrxBrowserScreen({Key key, this.title}) : super(key: key);
  @override
  TrxBrowserScreenState createState() => TrxBrowserScreenState();
}

String convertToFingerprintStringFormat(String str) {
  int numChunks = (str.length / 2).ceil();
  List<String> chunks = new List();
  for (int o = 0; o < numChunks * 2; o += 2) {
    chunks.add(str.substring(o, o + 2));
  }
  return chunks.join(':');
}

final JsonDecoder _decoder = new JsonDecoder();

class TrxBrowserScreenState extends State<TrxBrowserScreen> {
  var keyFingerprint = "";
  static var keyId;
  static var _date = DateFormat('E, d MMM y H:m:s', 'en_US');
  //Sun, 15 Nov 2020 10:40:51 GMT

  static final method = "GET";
  //static final target="/n/frhvjnni10jd/b/BlockChainSibylBucket/o?compartmentId=ocid1.compartment.oc1..aaaaaaaawoc74tyx4r4iksbgffs37vv7h2okwbi55wmsn53sv6rjxwh5b4qq";

  //    :7443/restproxy/bcsgw/rest/v1/transaction/invocation
  //Content-type:application/json -X POST -d '{"chaincode":"obcs-cardealer","channel":"default","chaincodeVer":"v0","args":["initVehiclePart","whl1241", "wizzard-auto", "1502688979", "wheel 28374", "mazida", "false", "1502688979"], "sync": true, "role":""}' https://sibylfounder-sibylit-fra.blockchain.ocp.oraclecloud.com:7443/restproxy/bcsgw/rest/v1/transaction/invocation

  var uri;
  static final alg = "rsa-sha256";
  static final sigVersion = "1";
  static var headers = "(request-target) date host";
  var sig;

  var dateHeader, hostHeader, signingString = "";
  String datenow;
  StoredObjects objectsFromServer;

  @override
  void initState() {
    super.initState();
    List<int> derFromPublicKey =
        decodePEM(encodePublicKeyToPem(globals.rsaPublicKey));
    String compressedKeyFingerprint = md5.convert(derFromPublicKey).toString();
    keyFingerprint = convertToFingerprintStringFormat(compressedKeyFingerprint);

    keyId = globals.tenancyId + "/" + globals.authUserId + "/" + keyFingerprint;
    datenow = _date.format(DateTime.now().toUtc()) + " GMT";
    globals.localLog("classname", "Datenow: " + datenow);

    dateHeader = "date: " + datenow;
    hostHeader = "host: " + globals.blockchainEndPointHost;
    //callsCars();
    callsOlio();
  }

  callsCars(){
    //callAPIVersion();
    String vehiclePartId="axbzg0"+Random(5).nextInt(99).toString();
    vehiclePartId="zz4312";
    /*callAPISetVehiclePartV1(vehiclePartId).then((bool result) => {
      if(result) callAPIQueryVehiclePart(vehiclePartId)
    });*/
    callAPISetVehiclePartV2(vehiclePartId).then((bool result) => {
      if(result) callAPIQueryVehiclePart(vehiclePartId)
    });
  }


  callsOlio(){
    //callAPISetLottoOlive("12345678901234000");
    callAPIQueryLottoOlive("12345678901234000");
    /*
    String frantoioId="axbzg0"+Random(5).nextInt(99).toString();
    frantoioId="zz4312";
    callAPISetLottoOlive(frantoioId).then((bool result) => {

    });*/
    /* Funziona in parte, problemi con frantoio ID
    callAPISetFrantoio(frantoioId).then((bool result) => {

    });*/

  }


  Future<bool> callAPIVersion() async {
    String function = "callAPIVersion";
    final target = ":7443/restproxy/api/version";
    uri = Uri.parse("https://" + globals.blockchainEndPointHost + target);
    final requestTarget =
        "(request-target): " + method.toLowerCase() + " " + target;
    signingString = "$requestTarget\n$dateHeader\n$hostHeader";
    sig = sign(
        Uint8List.fromList(signingString.codeUnits), globals.rsaPrivateKey);

    String authStr =
        "Signature version=\"$sigVersion\",keyId=\"$keyId\",algorithm=\"$alg\",headers=\"$headers\",signature=\"$sig\"";

    authStr = 'Basic ' +
        base64Encode(utf8.encode('antonino.bajeli@sibyl.it:Oraclecloudino@7'));
    Map<String, String> reqheaders = {
      'content-type': 'application/json',
      'accept': 'application/json',
      "date": datenow,
      "host": globals.blockchainEndPointHost,
      "Authorization": authStr
    };
    globals.localLog(function, uri.toString());
    globals.localLog(function, authStr.toString());
    var response = await http.get(uri, headers: reqheaders);
    globals.localLog(function, response.reasonPhrase);
    globals.localLog(function, response.body);
    final JsonDecoder _decoder = new JsonDecoder();
    return true;
  }


  Future<bool> callAPISetVehiclePartV1(String id) async {
    // Collaudato e funzionante!!!!!
    String function = "callAPISetAutoPart";
    final target = ":7443/restproxy/api/v2/channels/default/transactions";
    uri = Uri.parse("https://" + globals.blockchainEndPointHost + target);
    final requestTarget =
        "(request-target): " + method.toLowerCase() + " " + target;
    signingString = "$requestTarget\n$dateHeader\n$hostHeader";
    sig = sign(
        Uint8List.fromList(signingString.codeUnits), globals.rsaPrivateKey);
    String authStr =
        "Signature version=\"$sigVersion\",keyId=\"$keyId\",algorithm=\"$alg\",headers=\"$headers\",signature=\"$sig\"";
    authStr = 'Basic ' +
        base64Encode(utf8.encode('antonino.bajeli@sibyl.it:Oraclecloudino@7'));
    Map<String, String> reqheaders = {
      'content-type': 'application/json',
      'accept': 'application/json',
      "date": datenow,
      "host": globals.blockchainEndPointHost,
      "Authorization": authStr
    };
    // OK!!
    String data ='{"chaincode":"obcs-cardealer","channel":"default","args":["initVehiclePart", "'+id+'", "panama-parts","'+DateTime.now().microsecondsSinceEpoch.toString()+'", "airbag 2020","MANU_NAME", "false","2020-10-12"]}';
    var response = await http.post(uri, headers: reqheaders, body: data);
    if (response.reasonPhrase.compareTo("Forbidden") != 0) {
      TxResponse txResponse = response.body != null
          ? TxResponse.fromMap(_decoder.convert(response.body))
          : TxResponse("Null body", response.reasonPhrase, null);
      if (txResponse.result != null) {
        globals.localLog(function, txResponse.result.txid);
        globals.localLog(function, response.body);
        await callAPIGetTransaction(txResponse.result.txid);
        return true;
      } else {
        globals.localLog(function, txResponse.error);
      }
    } else {
      globals.localLog(function, response.reasonPhrase);
      globals.localLog(function, response.body);
    }
    return false;
  }


  Future<bool> callAPISetVehiclePartV2(String id) async {
    //
    // non funziona
    // ************************


    // Collaudato e funzionante!!!!!
    String function = "callAPISetAutoPart";
    final target = ":7443/restproxy/api/v2/channels/default/transactions";
    uri = Uri.parse("https://" + globals.blockchainEndPointHost + target);
    final requestTarget =
        "(request-target): " + method.toLowerCase() + " " + target;
    signingString = "$requestTarget\n$dateHeader\n$hostHeader";
    sig = sign(
        Uint8List.fromList(signingString.codeUnits), globals.rsaPrivateKey);
    String authStr =
        "Signature version=\"$sigVersion\",keyId=\"$keyId\",algorithm=\"$alg\",headers=\"$headers\",signature=\"$sig\"";
    authStr = 'Basic ' +
        base64Encode(utf8.encode('antonino.bajeli@sibyl.it:Oraclecloudino@7'));
    Map<String, String> reqheaders = {
      'content-type': 'application/json',
      'accept': 'application/json',
      "date": datenow,
      "host": globals.blockchainEndPointHost,
      "Authorization": authStr
    };
    // OK!!

   // String data ='{"chaincode":"obcs-cardealer","channel":"default","args":["createCar",{"assetType":"fabcar.car","vin":"vinandserialnum01","make":"ford","model":"hybrid","year":2015,"color":"black","owner":"joe@oracle.com","price":12000,"lastSold":"2020-10-20T06:00:00.000Z"}]}';

    String data ='{"chaincode":"obcs-cardealer","channel":"default","args":["addCar","vinandserialnum01","ford","hybrid",2015,"black","joe@oracle.com",12000,"2020-10-20T06:00:00.000Z"]}';


    var response = await http.post(uri, headers: reqheaders, body: data);
    if ((response.reasonPhrase.compareTo("Forbidden")!= 0)&&
        (response.reasonPhrase.compareTo("Bad Request") != 0)
       ){
      globals.localLog(function, response.body);
      TxResponse txResponse = response.body != null
          ? TxResponse.fromMap(_decoder.convert(response.body))
          : TxResponse("Null body", response.reasonPhrase, null);
      if (txResponse.result != null) {
        globals.localLog(function, txResponse.result.txid);
        globals.localLog(function, response.body);
        await callAPIGetTransaction(txResponse.result.txid);
        return true;
      } else {
        globals.localLog(function, txResponse.error);
      }
    } else {
      globals.localLog(function, response.reasonPhrase);
      globals.localLog(function, response.body);
    }
    return false;
  }


  callAPIQueryVehiclePart(String id) async {
    // Collaudato e funzionante!!!!!
    String function = "callAPIQueryVehiclePart";
    final target = ":7443/restproxy/api/v2/channels/default/chaincode-queries";
    uri = Uri.parse("https://" + globals.blockchainEndPointHost + target);
    final requestTarget =
        "(request-target): " + method.toLowerCase() + " " + target;
    signingString = "$requestTarget\n$dateHeader\n$hostHeader";
    sig = sign(
        Uint8List.fromList(signingString.codeUnits), globals.rsaPrivateKey);
    String authStr =
        "Signature version=\"$sigVersion\",keyId=\"$keyId\",algorithm=\"$alg\",headers=\"$headers\",signature=\"$sig\"";
    authStr = 'Basic ' +
        base64Encode(utf8.encode('antonino.bajeli@sibyl.it:Oraclecloudino@7'));
    Map<String, String> reqheaders = {
      'content-type': 'application/json',
      'accept': 'application/json',
      "date": datenow,
      "host": globals.blockchainEndPointHost,
      "Authorization": authStr
    };
    // OK!!
    String data ='{"chaincode":"obcs-cardealer","args":["readVehicle","'+id+'"]}';
    var response = await http.post(uri, headers: reqheaders, body: data);
    if (response.reasonPhrase.compareTo("Forbidden") != 0) {
      globals.localLog(function, response.body);
      VehiclePart vehiclePart = response.body != null
          ? VehiclePart.fromMap(_decoder.convert(response.body)["result"]["payload"])
          : VehiclePart("Null body", response.reasonPhrase, null,null,null,null,null);
      if (vehiclePart.serialNumber != null) {
        globals.localLog(function, vehiclePart.serialNumber);
        globals.localLog(function, vehiclePart.owner);
        globals.localLog(function, vehiclePart.assembler);
        globals.localLog(function, vehiclePart.assemblyDate.toIso8601String());
      }
    } else {
      globals.localLog(function, response.reasonPhrase);
      globals.localLog(function, response.body);
    }  }



  callAPISetAutoPartV2() async {
    String function = "callAPISetAutoPart";
    final target=":7443/restproxy/bcgw/rest/v1/transaction/invocation";

    uri = Uri.parse("https://" + globals.blockchainEndPointHost + target);
    final requestTarget =
        "(request-target): " + method.toLowerCase() + " " + target;
    signingString = "$requestTarget\n$dateHeader\n$hostHeader";
    sig = sign(
        Uint8List.fromList(signingString.codeUnits), globals.rsaPrivateKey);
    String authStr =
        "Signature version=\"$sigVersion\",keyId=\"$keyId\",algorithm=\"$alg\",headers=\"$headers\",signature=\"$sig\"";
    authStr = 'Basic ' +
        base64Encode(utf8.encode('antonino.bajeli@sibyl.it:Oraclecloudino@7'));
    Map<String, String> reqheaders = {
      'content-type': 'application/json',
      'accept': 'application/json',
      "date": datenow,
      "host": globals.blockchainEndPointHost,
      "Authorization": authStr
    };
    // OK!!
   //String data ='{"chaincode":"obcs-cardealer","channel":"default","args":["initVehiclePart", "abg1234", "panama-parts","1502688979", "airbag 2020","MANU_NAME", "false","1502688979"]}';

   String data ='{"chaincodeId":"obcs-cardealer","chaincodeVersion":"v0","method":"initVehiclePart","args":["a65432","t123332112","1606135785205","tony","tonysuper","false","0"]}';


    var response = await http.post(uri, headers: reqheaders, body: data);

    if (response.reasonPhrase.compareTo("Forbidden") != 0) {
      TxResponse txResponse = response.body != null
          ? TxResponse.fromMap(_decoder.convert(response.body))
          : TxResponse("Null body", response.reasonPhrase, null);
      if (txResponse.result != null) {
        globals.localLog(function, txResponse.result.txid);
        globals.localLog(function, response.body);
        callAPIGetTransaction(txResponse.result.txid);
      } else {
        globals.localLog(function, txResponse.error);
      }
    } else {
      globals.localLog(function, response.reasonPhrase);
      globals.localLog(function, response.body);
    }
  }


  Future<bool> callAPISetLottoOlive(String lottoId) async {
    String function = "callAPISetLottoOlive";
    final target = ":7443/restproxy/api/v2/channels/default/transactions";
    uri = Uri.parse("https://" + globals.blockchainEndPointHost + target);
    final requestTarget =
        "(request-target): " + method.toLowerCase() + " " + target;
    signingString = "$requestTarget\n$dateHeader\n$hostHeader";
    sig = sign(
        Uint8List.fromList(signingString.codeUnits), globals.rsaPrivateKey);
    String authStr =
        "Signature version=\"$sigVersion\",keyId=\"$keyId\",algorithm=\"$alg\",headers=\"$headers\",signature=\"$sig\"";
    authStr = 'Basic ' +
        base64Encode(utf8.encode('antonino.bajeli@sibyl.it:Oraclecloudino@7'));
    Map<String, String> reqheaders = {
      'content-type': 'application/json',
      'accept': 'application/json',
      "date": datenow,
      "host": globals.blockchainEndPointHost,
      "Authorization": authStr
    };

     String data =
       '{"chaincode":"TrueLink","channel":"default","args":["AddOlives","'+lottoId+'", "prod1","nocellara", "120"], "sync": true}';

    var response = await http.post(uri, headers: reqheaders, body: data);

    if ((response.reasonPhrase.compareTo("Forbidden") != 0)&&
    (response.reasonPhrase.compareTo("Bad Request") != 0)) {
      TxResponse txResponse = response.body != null
          ? TxResponse.fromMap(_decoder.convert(response.body))
          : TxResponse("Null body", response.reasonPhrase, null);
      if (txResponse.result != null) {
        globals.localLog(function, txResponse.result.txid);
        globals.localLog(function, response.body);
        callAPIGetTransaction(txResponse.result.txid);
      } else {
        globals.localLog(function, txResponse.error);
      }
    } else {
      globals.localLog(function, response.reasonPhrase);
      globals.localLog(function, response.body);
    }
    return true;
  }

  Future<bool> callAPISetFrantoio(String frantoioId) async {
    String function = "callAPISetFrantoio";
    final target = ":7443/restproxy/api/v2/channels/default/transactions";
    uri = Uri.parse("https://" + globals.blockchainEndPointHost + target);
    final requestTarget =
        "(request-target): " + method.toLowerCase() + " " + target;
    signingString = "$requestTarget\n$dateHeader\n$hostHeader";
    sig = sign(
        Uint8List.fromList(signingString.codeUnits), globals.rsaPrivateKey);
    String authStr =
        "Signature version=\"$sigVersion\",keyId=\"$keyId\",algorithm=\"$alg\",headers=\"$headers\",signature=\"$sig\"";
    authStr = 'Basic ' +
        base64Encode(utf8.encode('antonino.bajeli@sibyl.it:Oraclecloudino@7'));
    Map<String, String> reqheaders = {
      'content-type': 'application/json',
      'accept': 'application/json',
      "date": datenow,
      "host": globals.blockchainEndPointHost,
      "Authorization": authStr
    };
    //String data='{"chaincode":"TrueLink-cc","channel":"default","method":"createFrantoio","args":["Frant-ABC", "bajeli", "+39095095095"]}';
    // OK!!
    String data =
        '{"chaincode":"TrueLink-cc","channel":"default","frantoioId":"12342134","args":["createFrantoio","FrantoioId:1234321"]}';
   // String data =
     //   '{"chaincode":"TrueLink-cc","channel":"default","args":["addOlives","12345678901234567", "prod1","nocellara", "120"], "sync": true}';

    var response = await http.post(uri, headers: reqheaders, body: data);

    if (response.reasonPhrase.compareTo("Forbidden") != 0) {
      TxResponse txResponse = response.body != null
          ? TxResponse.fromMap(_decoder.convert(response.body))
          : TxResponse("Null body", response.reasonPhrase, null);
      if (txResponse.result != null) {
        globals.localLog(function, txResponse.result.txid);
        globals.localLog(function, response.body);
        callAPIGetTransaction(txResponse.result.txid);
      } else {
        globals.localLog(function, txResponse.error);
      }
    } else {
      globals.localLog(function, response.reasonPhrase);
      globals.localLog(function, response.body);
    }
    return true;
  }

  callAPISetTransaction() async {
    String function = "callAPISetTransaction";
    final target = ":7443/restproxy/api/v2/channels/default/transactions";
    uri = Uri.parse("https://" + globals.blockchainEndPointHost + target);
    final requestTarget =
        "(request-target): " + method.toLowerCase() + " " + target;
    signingString = "$requestTarget\n$dateHeader\n$hostHeader";
    sig = sign(
        Uint8List.fromList(signingString.codeUnits), globals.rsaPrivateKey);

    String authStr =
        "Signature version=\"$sigVersion\",keyId=\"$keyId\",algorithm=\"$alg\",headers=\"$headers\",signature=\"$sig\"";

    authStr = 'Basic ' +
        base64Encode(utf8.encode('antonino.bajeli@sibyl.it:Oraclecloudino@7'));
    Map<String, String> reqheaders = {
      'content-type': 'application/json',
      'accept': 'application/json',
      "date": datenow,
      "host": globals.blockchainEndPointHost,
      "Authorization": authStr
    };
    String data =
        '{"chaincode":"TrueLink-cc","channel":"default","chaincodeVer":"v0","args":["addOlives","12345678901234567", "prod1","nocellara", "120"], "sync": true}';

    var response = await http.post(uri, headers: reqheaders, body: data);

    TxResponse txResponse = response.body != null
        ? TxResponse.fromMap(_decoder.convert(response.body))
        : TxResponse("Null body", response.reasonPhrase, null);
    if (txResponse.result != null) {
      globals.localLog(function, txResponse.result.txid);
      callAPIGetTransaction(txResponse.result.txid);
    } else {
      globals.localLog(function, txResponse.error);
    }
  }

  callAPIQueryLottoOlive(String id) async {
    String function = "callAPIQueryLottoOlive";
    final target = ":7443/restproxy/api/v2/channels/default/chaincode-queries";
    uri = Uri.parse("https://" + globals.blockchainEndPointHost + target);
    final requestTarget =
        "(request-target): " + method.toLowerCase() + " " + target;
    signingString = "$requestTarget\n$dateHeader\n$hostHeader";
    sig = sign(
        Uint8List.fromList(signingString.codeUnits), globals.rsaPrivateKey);
    String authStr =
        "Signature version=\"$sigVersion\",keyId=\"$keyId\",algorithm=\"$alg\",headers=\"$headers\",signature=\"$sig\"";
    authStr = 'Basic ' +
        base64Encode(utf8.encode('antonino.bajeli@sibyl.it:Oraclecloudino@7'));
    Map<String, String> reqheaders = {
      'content-type': 'application/json',
      'accept': 'application/json',
      "date": datenow,
      "host": globals.blockchainEndPointHost,
      "Authorization": authStr
    };
    // OK!!
    String data ='{"chaincode":"TrueLink","args":["GetLottoOliveById","'+id+'"]}';
    var response = await http.post(uri, headers: reqheaders, body: data);
    globals.localLog(function, response.body);
    if ((response.reasonPhrase.compareTo("Forbidden") != 0)&&
        (response.reasonPhrase.compareTo("Bad Request") != 0)) {
      globals.localLog(function, response.body);
      LottoOlive lottoOlive = response.body != null
          ? LottoOlive.fromMap(_decoder.convert(response.body)["result"]["payload"])
          : LottoOlive("Null body", response.reasonPhrase, null,null);
      if (lottoOlive.lolivein != null) {
        globals.localLog(function, lottoOlive.lolivein);
        globals.localLog(function, lottoOlive.produttore);
        globals.localLog(function, lottoOlive.cultivar);
        globals.localLog(function, lottoOlive.pesoHg.toString());
      }
    } else {
      globals.localLog(function, response.reasonPhrase);
      globals.localLog(function, response.body);
    }  }


  callAPIQueryLottoOlives() async {
    String function = "callAPIQueryLottoOlive";
    final target = ":7443/restproxy/api/v2/channels/default/chaincode-queries";
    uri = Uri.parse("https://" + globals.blockchainEndPointHost + target);
    final requestTarget =
        "(request-target): " + method.toLowerCase() + " " + target;
    signingString = "$requestTarget\n$dateHeader\n$hostHeader";
    sig = sign(
        Uint8List.fromList(signingString.codeUnits), globals.rsaPrivateKey);
    String authStr =
        "Signature version=\"$sigVersion\",keyId=\"$keyId\",algorithm=\"$alg\",headers=\"$headers\",signature=\"$sig\"";
    authStr = 'Basic ' +
        base64Encode(utf8.encode('antonino.bajeli@sibyl.it:Oraclecloudino@7'));
    Map<String, String> reqheaders = {
      'content-type': 'application/json',
      'accept': 'application/json',
      "date": datenow,
      "host": globals.blockchainEndPointHost,
      "Authorization": authStr
    };
    // OK!!
    String data ='{"chaincode":"TrueLink","args":["GetLottoOliveByRange","",""]}';
    var response = await http.post(uri, headers: reqheaders, body: data);
    globals.localLog(function, response.body);
    if ((response.reasonPhrase.compareTo("Forbidden") != 0)&&
        (response.reasonPhrase.compareTo("Bad Request") != 0)) {
      globals.localLog(function, response.body);
      LottoOlive lottoOlive = response.body != null
          ? LottoOlive.fromMap(_decoder.convert(response.body)["result"]["payload"])
          : LottoOlive("Null body", response.reasonPhrase, null,null);
      if (lottoOlive.lolivein != null) {
        globals.localLog(function, lottoOlive.lolivein);
        globals.localLog(function, lottoOlive.produttore);
        globals.localLog(function, lottoOlive.cultivar);
        globals.localLog(function, lottoOlive.pesoHg.toString());
      }
    } else {
      globals.localLog(function, response.reasonPhrase);
      globals.localLog(function, response.body);
    }  }


  callAPIGetTransaction(String txid) async {
    String function = "callAPIGetTransaction";
    String target;
    if (txid != null) {
      target = ":7443/restproxy/api/v2/channels/default/transactions/" + txid;
    } else {
      target =
          ":7443/restproxy/api/v2/channels/default/transactions/8771e368f488776235fc9d677520b3833499d52226d812e1ecec1713ffa46bae";
    }
    uri = Uri.parse("https://" + globals.blockchainEndPointHost + target);
    final requestTarget =
        "(request-target): " + method.toLowerCase() + " " + target;
    signingString = "$requestTarget\n$dateHeader\n$hostHeader";
    sig = sign(
        Uint8List.fromList(signingString.codeUnits), globals.rsaPrivateKey);

    String authStr =
        "Signature version=\"$sigVersion\",keyId=\"$keyId\",algorithm=\"$alg\",headers=\"$headers\",signature=\"$sig\"";

    authStr = 'Basic ' +
        base64Encode(utf8.encode('antonino.bajeli@sibyl.it:Oraclecloudino@7'));
    Map<String, String> reqheaders = {
      'content-type': 'application/json',
      'accept': 'application/json',
      "date": datenow,
      "host": globals.blockchainEndPointHost,
      "Authorization": authStr
    };
    globals.localLog(function, uri.toString());
    globals.localLog(function, authStr.toString());
    var response = await http.get(uri, headers: reqheaders);
    globals.localLog(function, response.reasonPhrase);
    globals.localLog(function, response.body);
    final JsonDecoder _decoder = new JsonDecoder();
  }

  callAPITransactions2() async {
    String function = "callAPITransactions2";
    final target = ":7443/restproxy/bcsgw/rest/v1/transaction/query";
    uri = Uri.parse("https://" + globals.blockchainEndPointHost + target);
    final requestTarget =
        "(request-target): " + method.toLowerCase() + " " + target;
    signingString = "$requestTarget\n$dateHeader\n$hostHeader";
    sig = sign(
        Uint8List.fromList(signingString.codeUnits), globals.rsaPrivateKey);

    String authStr =
        "Signature version=\"$sigVersion\",keyId=\"$keyId\",algorithm=\"$alg\",headers=\"$headers\",signature=\"$sig\"";

    authStr = 'Basic ' +
        base64Encode(utf8.encode('antonino.bajeli@sibyl.it:Oraclecloudino@7'));
    Map<String, String> reqheaders = {
      'content-type': 'application/json',
      'accept': 'application/json',
      "date": datenow,
      "host": globals.blockchainEndPointHost,
      "Authorization": authStr
    };
    globals.localLog("storage call uri", uri.toString());
    globals.localLog("storage call aut", authStr.toString());
    var response = await http.post(uri,
        headers: reqheaders,
        body:
            '{"channel": "default", "ChaincodeID": "obcs-cardealer","ChaincodeVer": "v0", "Fcn": "queryVehiclePartByOwner","args": ["mercedes"]}');

    globals.localLog(function, response.reasonPhrase);
    globals.localLog(function, response.body);
    final JsonDecoder _decoder = new JsonDecoder();
  }

  Widget _objectsListView(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: objectsFromServer.objects.length,
      itemBuilder: (context, index) {
        return ListTile(
          //leading: Container(width:10,height: 20.0,child:Container(width:10,height: 50.0,)),

          leading: Container(
              width: 60,
              height: 80.0,
              child: FutureBuilder(
                initialData: Container(),
                builder: (context, projectSnap) {
                  if (projectSnap.connectionState == ConnectionState.none &&
                      projectSnap.hasData == null) {
                    //print('project snapshot data is: ${projectSnap.data}');
                    return Container();
                    // ignore: missing_return
                  }
                  return projectSnap.data;
                },
                future: ObjectsAPI.wrapActionButtonImage(context,
                    objectsFromServer.objects.elementAt(index).name, 20, 20),
              )),

          title: Text(objectsFromServer.objects.elementAt(index).name),
          //subtitle: FlatButton(child:Text("View"),onPressed:() => buttonStoredObjectDetailAction(context,objectsFromServer.objects.elementAt(index).name),),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: Container(),
      /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {}
      ),*/
    );
  }
}
