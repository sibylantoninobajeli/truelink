
class VehiclePart{

//#"payload":
// {"docType":"vehiclePart","serialNumber":"abg1234","assembler":"panama-parts",
// "assemblyDate":1502688979,"name":"airbag 2020","owner":"manu_name","recall":false,"recallDate":1502688979}

  String serialNumber;
  String assembler;
  DateTime assemblyDate;
  //":1502688979,
  String name;
  String owner;
  bool recall;
  DateTime recallDate;
//":1502688979}


  VehiclePart(this.serialNumber, this.assembler, this.assemblyDate, this.name,
      this.owner, this.recall, this.recallDate);

  VehiclePart.fromMap(Map<String, dynamic> map){
    serialNumber=(map['serialNumber']);
    assembler=(map['assembler']);
    assemblyDate=(map['assemblyDate']!=null)?DateTime.fromMicrosecondsSinceEpoch(map['assemblyDate']):null;
    name=(map['name']);
    owner=(map['owner']);
    recall=(map['recall']!=null)?map['recall']:false;
    recallDate=(map['recallDate']!=null)?DateTime.fromMicrosecondsSinceEpoch(map['recallDate']):null;
  }


}
