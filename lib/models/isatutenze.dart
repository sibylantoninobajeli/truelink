
import 'user.dart';
class Isatutenze{
  Isatutenze.pluslistIstituto( this.user, this.cell, this.isMadre, this.isPadre, this.isLeader,
      this.logged, this.loginTkn, this.pushTokenGl, this.pushTokenItune);

  Isatutenze( this.user, this.cell, this.isMadre, this.isPadre, this.isLeader,
      this.logged, this.loginTkn, this.pushTokenGl, this.pushTokenItune);

  User user;
  String cell;
  bool isMadre;
  bool isPadre;
  bool isLeader;
  bool logged;
  String avatar;
  String loginTkn;
  String pushTokenGl;
  String pushTokenItune;

  Isatutenze.createFromEmail(String email){
    user=User.fromEmail(email);
  }

  Isatutenze.fromMap(Map<String, dynamic> map) {
    //map.containsKey("id")?this.id=int.parse(map["id"]);
    if (map.containsKey("user")) this.user=User.fromDbMap(map["user"]);



    this.cell = map['cell'];
    this.isMadre = (map['isMadre'] !=null)?map['isMadre']:false;
    this.isPadre = (map['isPadre'] !=null)?map['isPadre']:false;
    this.isLeader = (map['isLeader'] !=null)?map['isLeader']:false;
    this.logged = (map['logged'] !=null)?map['logged']:false;
    //this.avatar = (map['avatar'] !=null)?map['avatar']:"https://secure.gravatar.com/userimage/5/2873000ea367cd46cae55418e4eac32c?size=420";
    this.avatar = (map['avatar'] !=null )?map['avatar']:(
         (user!=null && user.id!=null)?"picture_${user.id}.jpeg"
        :"https://secure.gravatar.com/userimage/5/2873000ea367cd46cae55418e4eac32c?size=420");



//https://storage.cloud.google.com/staging.infoscuolapp.appspot.com/picture_${user.id}.jpeg
    this.loginTkn = map['loginTkn'];
    this.pushTokenGl = map['pushTokenGl'];
    this.pushTokenItune = map['pushTokenItune'];

  }

  String getCell(){
    return (cell!=null)?cell:"-------";
  }

  String getGenitorialita(){
    if (isPadre){
      return "padre";
    }else{
      if (isMadre){
        return "madre";
      } return "Indefinito";
    }
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = user.id;
    map["cell"] = cell;
    map["isMadre"] = isMadre;
    map["isPadre"] = isPadre;
    map["isLeader"] = isLeader;
    map["logged"] = logged;
    map["loginTkn"] = loginTkn;
    map["pushTokenGl"] = pushTokenGl;
    map["pushTokenItune"] = pushTokenItune;

    return map;
  }

  String toStringPersonContacts(){
    return ((cell!=null)?cell:"-?")
        +" "+
        ((user!=null&&(user.email!=null))?user.email:"-?")
    ;
  }

  String toStringPersonName(){
    return
      ((user!=null&&user.firstName!=null)?user.firstName:"-?")
          +" "+((user!=null&&user.lastName!=null)?user.lastName:"-?")
    ;
  }
}