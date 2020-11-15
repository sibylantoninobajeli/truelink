import 'dart:io';
import 'dart:typed_data';
import 'package:truelink/globals.dart' as globals;
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:pointycastle/api.dart' as api;
import 'package:pointycastle/asymmetric/api.dart';
import '../blockchain/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';


class KeyGeneratorScreen extends StatefulWidget {
  @override
  KeyGeneratorScreenState createState() => KeyGeneratorScreenState();
}



class KeyGeneratorScreenState extends State<KeyGeneratorScreen> {

  api.AsymmetricKeyPair<api.PublicKey, api.PrivateKey> keypair;
  Digest md5str;
  bool ready;

  Future<File> _writeToFile(String encodedString, String filename) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final file = new File('$tempPath/$filename');
    await file.writeAsString(encodedString);

    return file;
  }


  _makeKeypairRequest() async {
    try {
      var pair = await makeGenerationRequest();
      String public_pem = encodePublicKeyToPem(pair.publicKey);
      String private_pem = encodePrivateKeyToPem(pair.privateKey);

      var filepupem = await _writeToFile(public_pem, "public_key.pem");
      var fileprpem = await _writeToFile(private_pem, "private_key.pem");

      //var input = File(filepem);
      md5str = await md5
          .bind(filepupem.openRead())
          .first;

      globals.saveRsaKeys(pair);


      final Email email = Email(
        body: 'In allegato la mia Public Key',
        subject: 'Chiave pubblica',
        recipients: ['abajeli.sibyl@gmail.com'],
        //cc: ['cc@example.com'],
        //bcc: ['bcc@example.com'],
        attachmentPaths: [filepupem.uri.path,fileprpem.uri.path],
        isHTML: false,
      );

      String platformResponse;
      try {
        await FlutterEmailSender.send(email);
        platformResponse = 'success';
      } catch (error) {
        platformResponse = error.toString();
      }

      setState(() {
        keypair = pair;

      });
    }catch(e){

    }

      setState(() {
      ready = true;
      });

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
            width: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                  minWidth: 400.0,
                  height: 40.0,
                  textTheme: ButtonTextTheme.primary,
                  child: RaisedButton(
                    child: Text('Generate Key Pair'),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          });
                      await _makeKeypairRequest();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(child: Text(keypair!=null?encodePublicKeyToPem(keypair.publicKey):"")),

                Container(child: Text(md5str!=null?hex.encode(md5str.bytes) :""))



              ],
            )));
  }
}

class OracleFabricBCWidgetState {

}
