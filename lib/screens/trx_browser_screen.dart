import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';  //for date format
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  for (int o = 0; o < numChunks*2; o += 2) {
    chunks.add(str.substring(o, o+2));
  }
  return chunks.join(':');
}


class TrxBrowserScreenState extends State<TrxBrowserScreen> {



  var keyFingerprint="";
  static var keyId;
  static var _date= DateFormat('E, d MMM y H:m:s','en_US');
  //Sun, 15 Nov 2020 10:40:51 GMT

  static final method="GET";
  //static final target="/n/frhvjnni10jd/b/BlockChainSibylBucket/o?compartmentId=ocid1.compartment.oc1..aaaaaaaawoc74tyx4r4iksbgffs37vv7h2okwbi55wmsn53sv6rjxwh5b4qq";

  //    :7443/restproxy/bcsgw/rest/v1/transaction/invocation
  //Content-type:application/json -X POST -d '{"chaincode":"obcs-cardealer","channel":"default","chaincodeVer":"v0","args":["initVehiclePart","whl1241", "wizzard-auto", "1502688979", "wheel 28374", "mazida", "false", "1502688979"], "sync": true, "role":""}' https://sibylfounder-sibylit-fra.blockchain.ocp.oraclecloud.com:7443/restproxy/bcsgw/rest/v1/transaction/invocation

  var uri;
  static final alg="rsa-sha256";
  static final sigVersion="1";
  static var headers="(request-target) date host";
  var sig;

  var dateHeader,hostHeader,signingString="";
  String datenow;
  StoredObjects objectsFromServer;

  @override
  void initState() {
    super.initState();
    List<int> derFromPublicKey=decodePEM(encodePublicKeyToPem(globals.rsaPublicKey));
    String compressedKeyFingerprint =md5.convert(derFromPublicKey).toString();
    keyFingerprint=convertToFingerprintStringFormat(compressedKeyFingerprint);

    keyId=globals.tenancyId+"/"+globals.authUserId+"/"+keyFingerprint;
    datenow=_date.format(DateTime.now().toUtc()) + " GMT";
    globals.localLog("classname", "Datenow: "+datenow);

    dateHeader="date: "+datenow;
    hostHeader="host: "+globals.blockchainEndPointHost;


    //sig = "iro/BGeKEwX4miFoHRXqIVNPLUnvulwnTMZozhikz8X9IRJ4FoodZTCy/1SvEvJdhfR97Q23KEsEoxhQGfn2MYFS8UnIVkiZ9tl5dq+GlxbjFRGfT8q75Vc/Aciqvj1/nyazAKME8d8fcWz8OlYPXrTgiemKCgwK2WTihlf/6ungburfuB1E3jL5jFXqEwO2BUamfm6+EzDudj6a1QRxtYg5zvllNr+9gQUathlXlmbIhDsU753DoxC4BnLtAIiHcoyGbhcpj+k8cu1cn1KyGc8AXN9hQvxDqDRzWcpMsAA/uUOlM2+6aQP8kuC2bJm9PDiqbog+vhZLNV9aaks1EQ==";

    callAPIVersion();

    callAPITransactions();
  }

  callAPIVersion() async {
    final target=":7443/restproxy/api/version";
    uri = Uri.parse("https://"+globals.blockchainEndPointHost+target);
    final requestTarget="(request-target): "+method.toLowerCase()+" "+target;
    signingString="$requestTarget\n$dateHeader\n$hostHeader";
    sig = sign(Uint8List.fromList(signingString.codeUnits), globals.rsaPrivateKey);



    String authStr="Signature version=\"$sigVersion\",keyId=\"$keyId\",algorithm=\"$alg\",headers=\"$headers\",signature=\"$sig\"";

    authStr='Basic ' + base64Encode(utf8.encode('antonino.bajeli@sibyl.it:Oraclecloudino@7'));
    Map<String,String> reqheaders={'content-type': 'application/json','accept': 'application/json', "date":datenow,"host":globals.blockchainEndPointHost,"Authorization":authStr };
    globals.localLog("storage call uri", uri.toString());
    globals.localLog("storage call aut", authStr.toString());
    var response = await http.get(uri,headers: reqheaders);
    globals.localLog("storage call", response.reasonPhrase);
    globals.localLog("storage call", response.body);
    final JsonDecoder _decoder = new JsonDecoder();
  }

  callAPITransactions() async {
    final target=":7443/restproxy/api/v2/channels/default/transactions/8771e368f488776235fc9d677520b3833499d52226d812e1ecec1713ffa46bae";
    uri = Uri.parse("https://"+globals.blockchainEndPointHost+target);
    final requestTarget="(request-target): "+method.toLowerCase()+" "+target;
    signingString="$requestTarget\n$dateHeader\n$hostHeader";
    sig = sign(Uint8List.fromList(signingString.codeUnits), globals.rsaPrivateKey);



    String authStr="Signature version=\"$sigVersion\",keyId=\"$keyId\",algorithm=\"$alg\",headers=\"$headers\",signature=\"$sig\"";

    authStr='Basic ' + base64Encode(utf8.encode('antonino.bajeli@sibyl.it:Oraclecloudino@7'));
    Map<String,String> reqheaders={'content-type': 'application/json','accept': 'application/json', "date":datenow,"host":globals.blockchainEndPointHost,"Authorization":authStr };
    globals.localLog("storage call uri", uri.toString());
    globals.localLog("storage call aut", authStr.toString());
    var response = await http.get(uri,headers: reqheaders);
    globals.localLog("storage call", response.reasonPhrase);
    globals.localLog("storage call", response.body);
    final JsonDecoder _decoder = new JsonDecoder();
  }


  Widget _objectsListView(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: objectsFromServer.objects.length,
      itemBuilder: (context, index) {
        return ListTile(
            //leading: Container(width:10,height: 20.0,child:Container(width:10,height: 50.0,)),

          leading: Container(width:60,height: 80.0,child: FutureBuilder(
            initialData: Container(),
            builder: (context, projectSnap) {
                    if (projectSnap.connectionState == ConnectionState.none &&
                        projectSnap.hasData == null) {
                      //print('project snapshot data is: ${projectSnap.data}');
                      return Container();
                    // ignore: missing_return
                    } return projectSnap.data;
                  },
            future: ObjectsAPI.wrapActionButtonImage(context,objectsFromServer.objects.elementAt(index).name,20,20),
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
      body: Container(

      ),
      /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {}
      ),*/
    );
  }

}