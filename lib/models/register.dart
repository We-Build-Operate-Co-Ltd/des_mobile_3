import 'package:flutter/material.dart';

class Register {
  String firstName = '';
  String lastName = '';
  String email = "";
  String category = "";
  String code = "";
  String username = "";
  String password = "";
  bool isActive;
  String status = "";
  String createBy = "";
  String createDate = "";
  String imageUrl = "";
  String updateBy = "";
  String updateDate = "";
  String birthDay = "";
  String phone = "";
  String facebookID = "";
  String googleID = "";
  String lineID = "";
  String line = "";
  String sex = "";
  String address = "";
  String tambonCode = "";
  String tambon = "";
  String amphoeCode = "";
  String amphoe = "";
  String provinceCode = "";
  String province = "";
  String postnoCode = "";
  String postno = "";
  String job = "";
  String idcard = "";
  String countUnit = "";
  String lv0 = "";
  String lv1 = "";
  String lv2 = "";
  String lv3 = "";
  String lv4 = "";

  Register(
    this.firstName,
    this.lastName,
    this.email,
    this.category,
    this.code,
    this.username,
    this.password,
    this.isActive,
    this.status,
    this.createBy,
    this.createDate,
    this.imageUrl,
    this.updateBy,
    this.updateDate,
    this.birthDay,
    this.phone,
    this.facebookID,
    this.googleID,
    this.lineID,
    this.line,
    this.sex,
    this.address,
    this.tambonCode,
    this.tambon,
    this.amphoeCode,
    this.amphoe,
    this.provinceCode,
    this.province,
    this.postnoCode,
    this.postno,
    this.job,
    this.idcard,
    this.countUnit,
    this.lv0,
    this.lv1,
    this.lv2,
    this.lv3,
    this.lv4,
  );

  Register.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'],
        category = json['category'],
        code = json['code'],
        username = json['username'],
        password = json['password'],
        isActive = json['isActive'],
        status = json['status'],
        createBy = json['createBy'],
        createDate = json['createDate'],
        imageUrl = json['imageUrl'],
        updateBy = json['updateBy'],
        updateDate = json['updateDate'],
        birthDay = json['birthDay'],
        phone = json['phone'],
        facebookID = json['facebookID'],
        googleID = json['googleID'],
        lineID = json['lineID'],
        line = json['line'],
        sex = json['sex'],
        address = json['address'],
        tambonCode = json['tambonCode'],
        tambon = json['tambon'],
        amphoeCode = json['amphoeCode'],
        amphoe = json['amphoe'],
        provinceCode = json['provinceCode'],
        province = json['province'],
        postnoCode = json['postnoCode'],
        postno = json['postno'],
        job = json['job'],
        idcard = json['idcard'],
        countUnit = json['countUnit'],
        lv0 = json['lv0'],
        lv1 = json['lv1'],
        lv2 = json['lv2'],
        lv3 = json['lv3'],
        lv4 = json['lv4'];

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'category': category,
        'code': code,
        'username': username,
        'password': password,
        'isActive': isActive,
        'status': status,
        'createBy': createBy,
        'createDate': createDate,
        'imageUrl': imageUrl,
        'updateBy': updateBy,
        'updateDate': updateDate,
        'birthDay': birthDay,
        'phone': phone,
        'facebookID': facebookID,
        'googleID': googleID,
        'lineID': lineID,
        'line': line,
        'sex': sex,
        'address': address,
        'tambonCode': tambonCode,
        'tambon': tambon,
        'amphoeCode': amphoeCode,
        'amphoe': amphoe,
        'provinceCode': provinceCode,
        'province': province,
        'postnoCode': postnoCode,
        'postno': postno,
        'job': job,
        'idcard': idcard,
        'countUnit': countUnit,
        'lv0': lv0,
        'lv1': lv1,
        'lv2': lv2,
        'lv3': lv3,
        'lv4': lv4,
      };

  save() => debugPrint('saving user using a web service');
}
