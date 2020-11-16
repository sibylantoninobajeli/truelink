class StoredObject {
  String name;
  DateTime modified;
  String md5;

  StoredObject(this.name);
  StoredObject.fromMap(Map<String, dynamic> map) {
    this.name = (map['name']);
  }

  StoredObject.setHeaders(Map<String, dynamic> map){
    this.modified =  (map['last-modified']!=null)?DateTime.parse(map['last-modified']):null;
    this.md5 =  map['content-md5'];
  }
}

class StoredObjects {
  List<StoredObject> objects;

  StoredObjects({this.objects});

  StoredObjects.fromMap(Map<String, dynamic> map)
      : objects = new List<StoredObject>.from(
                          map["objects"].map((name) => new StoredObject.fromMap(name)));


}

