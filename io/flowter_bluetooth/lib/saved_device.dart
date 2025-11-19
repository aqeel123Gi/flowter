part of 'flowter_bluetooth.dart';

class BluePairedDevice {
  String id;
  String name;
  BluePairedDevice({required this.id, required this.name});

  Map<String, String> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }

  static BluePairedDevice fromMap(dynamic map) {
    return BluePairedDevice(
      id: map["id"]!,
      name: map["name"]!,
    );
  }
}
