import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String lv;
  String mail;
  String point;


  UserModel(
      {this.id,
        this.name,
        this.lv,
        this.mail,
        this.point,

      });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['uid'];
    name = json['name'];
    lv = json['level'];
    mail = json['email'];
    point = json['point'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.id;
    data['name'] = this.name;
    data['email'] = this.mail;
    data['level'] = this.lv;
    data['point'] = this.point;
    return data;
  }
}