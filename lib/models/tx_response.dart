class TxResponse {
  String returnCode,error;
  DateTime modified;
  Result result;
  TxResponse(this.returnCode,this.error,this.result);
  TxResponse.fromMap(Map<String, dynamic> map) {
    this.returnCode = (map['returnCode']);
    this.error = (map['error']);
    this.result = Result.fromMap(map['result']);
  }
}

class Result {
  String txid;
  String payload;
  String encode;

  Result({this.txid,this.payload,this.encode});
  Result.fromMap(Map<String, dynamic> map){
    this.txid = (map['txid']);
    this.payload = (map['payload']);
    this.encode = (map['encode']);
  }


}

