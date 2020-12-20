import 'maintenanceRecord.dart';

class Data{
  String name;
  String id;
  String desc; // Optional
  bool warranty;
  String comments; // Optional

  List<MainRec> records;

  Data({this.name, this.id, this.desc, this.warranty, this.comments, this.records});
}