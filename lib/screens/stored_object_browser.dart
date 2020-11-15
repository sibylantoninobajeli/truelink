import 'dart:typed_data';
import 'package:intl/intl.dart';  //for date format
import 'package:intl/date_symbol_data_local.dart';  //for date locale
import 'package:intl/date_symbols.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:pointycastle/asymmetric/api.dart';
import '../blockchain/crypto.dart';
import 'package:truelink/globals.dart' as globals;


class StoredObjectsScreen extends StatefulWidget {
  final title;
  StoredObjectsScreen({Key key, this.title}) : super(key: key);
  @override
  StoredObjectsScreenState createState() => StoredObjectsScreenState();
}



class StoredObjectsScreenState extends State<StoredObjectsScreen> {
  final tenancyId="ocid1.tenancy.oc1..aaaaaaaaim3faii6ffmkujfczxiz6e4ezw5ogmj4ftqwosi7tyw4fstdkitq";
  final authUserId="ocid1.user.oc1..aaaaaaaaxofkollklmasvqzvycdjw5wpx47dlk3kfqz2n63ygrpdby3dysdq";
  final keyFingerprint="29:fb:09:6f:81:8a:28:ae:ec:2c:8f:89:46:fc:08:fc";
  static var keyId;
  static var _date= DateFormat('E, d MMM y H:m:s','en_US');
  //Sun, 15 Nov 2020 10:40:51 GMT

  static final host="objectstorage.eu-frankfurt-1.oraclecloud.com";
  static final method="GET";
  static final target="/n/frhvjnni10jd/b/BlockChainSibylBucket/o?compartmentId=ocid1.compartment.oc1..aaaaaaaawoc74tyx4r4iksbgffs37vv7h2okwbi55wmsn53sv6rjxwh5b4qq";
  var uri;
  static final alg="rsa-sha256";
  static final sigVersion="1";
  static var headers="(request-target) date host";
  var sig;
  final request_target="(request-target): "+method.toLowerCase()+" "+target;
  var date_header,host_header,signing_string="";
  String datenow;

  @override
  void initState() {
    super.initState();
    keyId="$tenancyId/$authUserId/$keyFingerprint";
    datenow=_date.format(DateTime.now().toUtc()) + " GMT";
    globals.localLog("classname", "Datenow: "+datenow);

    date_header="date: "+datenow;
    host_header="host: $host";

    globals.localLog("classname","request target: "+ request_target);

    signing_string="$request_target\n$date_header\n$host_header";

    //signing_string="(request-target): get /n/frhvjnni10jd/b/BlockChainSibylBucket/o?compartmentId=ocid1.compartment.oc1..aaaaaaaawoc74tyx4r4iksbgffs37vv7h2okwbi55wmsn53sv6rjxwh5b4qq\ndate: Sun, 15 Nov 2020 21:47:14 GMT\nhost: objectstorage.eu-frankfurt-1.oraclecloud.com";

    sig = sign(Uint8List.fromList(signing_string.codeUnits), globals.rsaPrivateKey);

    //sig = "iro/BGeKEwX4miFoHRXqIVNPLUnvulwnTMZozhikz8X9IRJ4FoodZTCy/1SvEvJdhfR97Q23KEsEoxhQGfn2MYFS8UnIVkiZ9tl5dq+GlxbjFRGfT8q75Vc/Aciqvj1/nyazAKME8d8fcWz8OlYPXrTgiemKCgwK2WTihlf/6ungburfuB1E3jL5jFXqEwO2BUamfm6+EzDudj6a1QRxtYg5zvllNr+9gQUathlXlmbIhDsU753DoxC4BnLtAIiHcoyGbhcpj+k8cu1cn1KyGc8AXN9hQvxDqDRzWcpMsAA/uUOlM2+6aQP8kuC2bJm9PDiqbog+vhZLNV9aaks1EQ==";

    uri = Uri.parse("https://"+host+target);



    callAPI();

  }


  callAPI() async {
    String authStr="Signature version=\"$sigVersion\",keyId=\"$keyId\",algorithm=\"$alg\",headers=\"$headers\",signature=\"$sig\"";
    //authStr='Signature version="1",keyId="ocid1.tenancy.oc1..aaaaaaaaim3faii6ffmkujfczxiz6e4ezw5ogmj4ftqwosi7tyw4fstdkitq/ocid1.user.oc1..aaaaaaaaxofkollklmasvqzvycdjw5wpx47dlk3kfqz2n63ygrpdby3dysdq/29:fb:09:6f:81:8a:28:ae:ec:2c:8f:89:46:fc:08:fc",algorithm="rsa-sha256",headers="(request-target) date host",signature="kPlqffONoOyl/JFyP/P5JOio2pCovYfEtKfDlUuh3XngrpdH4LmvxraVWEaL8PY38xqc8+QWQp2lt57IPPeMuL56KOu5EoQy9dL2KOZlS1aYborReB7qRpaS4rGdvQOxWxyw+G/SVQm5C2IkCBHNdOWLFtvp2mwHwYAlu2GsaLEk8wrXF6FkyJKVy9lj8B5Dp9WJvoaoz/AGpedCuiSNJrfCVnLMLVVyIQSVYuo1Dyb5GL2BerKwQ+ez1w3zQEuRa9N5T+DIIvl29Fsyy6h7naNU+TNAFRhlnQCjDrOz5jkLOO1uWl5J3Yd2/oApa1L3PKEKTR7xZlXBVgQjxC61BQ=="';
    Map<String,String> reqheaders={ "date":datenow,"host":host,"Authorization":authStr };
    globals.localLog("storage call uri", uri.toString());
    globals.localLog("storage call aut", authStr.toString());
    var response = await http.get(uri,headers: reqheaders);
    globals.localLog("storage call", response.reasonPhrase);
    globals.localLog("storage call", response.body);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: Container( child:
      Column(children: [
        Text(_date.format(DateTime.now().toUtc()) + " GMT " ),
        Text(globals.rsaPrivateKey.toString()),
        Text(globals.rsaPublicKey.toString()),
        FlatButton(child:Text("Call API"),onPressed: callAPI,)


      ],)

      ),
      /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {}
      ),*/
    );
  }

}