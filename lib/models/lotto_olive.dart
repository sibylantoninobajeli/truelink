
class LottoOlive{
//#"payload":
// {"docType":"TrueLink.LottoOlive","Lolivein":"12345678901234568","Produttore":"1234567","Cultivar":"nocellare","PesoHg":1}
  String lolivein;
  String produttore;
  String cultivar;
  int pesoHg;

  LottoOlive(this.lolivein, this.produttore, this.cultivar, this.pesoHg);

  LottoOlive.fromMap(Map<String, dynamic> map){
    lolivein=(map['Lolivein']);
    produttore=(map['Produttore']);
    cultivar=(map['Cultivar']);
    pesoHg=(map['PesoHg']);
  }


}
