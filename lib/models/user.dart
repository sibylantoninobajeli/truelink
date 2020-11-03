class User {

  User(this.id, this.username, this.password,this.lastName, this.firstName,this.email, this.lastLogin);

  int id;
  String username;
  String password;
  String lastName;
  String firstName;
  DateTime lastLogin;
  String email;

  User.fromEmail(this.email){
    username=email.split('@').elementAt(0);
    firstName=username;
    lastName=username;
  }

  User.fromDbMap(Map<String, dynamic> map) {
    if (map.containsKey("id")){
      try{
        this.id = int.parse(map['id']);
      }catch(exception){
        this.id = map['id'];
      }
    }

    this.username = (map['username']);
    this.lastName = (map['lastName']!=null)?map['lastName']:"";
    this.firstName = (map['firstName']!=null)?map['firstName']:"";
    this.lastLogin = (map['lastLogin']!=null)?DateTime.parse(map['lastLogin']):null;
    this.email = map['email'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["username"] = username;
    map["lastName"] = lastName;
    map["firstName"] = firstName;
    map["lastLogin"] = (lastLogin!=null)?lastLogin.toIso8601String():null;
    map["email"] = email;

    return map;
  }

  String shortDescr(){
    return getCompleteName()+" - "+
        ((email!=null)?email:"-?");
  }

  String getCompleteName(){
    return ((firstName!=null)?firstName:"-?")
        +" "+
        ((lastName!=null)?lastName:"-?")
        ;
  }


  String toStringCapitalizedName(){
    String name= (firstName!=null && firstName.length>1) ?firstName.substring(0,1).toUpperCase()+firstName.substring(1).toLowerCase():"?";
    name=(lastName!=null && lastName.length>1)?name+" "+ lastName.substring(0,1).toUpperCase()+lastName.substring(1).toLowerCase():name+"?";
    if (name.length<4) name=name+" "+((username!=null)?username:"?");
    return name;
  }


/*
  getId() => this.id;
  getUsername() => this.username;
  getLastName() => this.lastName;
  getEmail() => this.email;
*/
}
