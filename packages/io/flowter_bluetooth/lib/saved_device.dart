part of 'flowter_bluetooth.dart';


class SavedDevice{
  String id;
  String name;
  DeviceType type;
  SavedDevice({required this.id,required this.name, required this.type});


  Map<String,String> toMap(){
    return {
      "id":id,
      "name":name,
      "type":type.name,
    };
  }

  static SavedDevice fromMap(dynamic map){
    return SavedDevice(
      id: map["id"]!,
      name: map["name"]!,
      type: DeviceType.values.byName(map["type"]!),
    );
  }
}