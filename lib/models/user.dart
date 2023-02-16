import 'package:flutter/material.dart';

class LoginRegister {
  String? status;
  String? message;
  User? objectData;

  LoginRegister({
    this.status,
    this.message,
    this.objectData,
  });

  static Map<String, dynamic> toMap(LoginRegister loginRegister) {
    var map = <String, dynamic>{};
    map['status'] = loginRegister.status;
    map['message'] = loginRegister.message;
    map['objectData'] = User.toMap(loginRegister);
    return map;
  }

  LoginRegister.map(dynamic obj) {
    status = obj["status"];
    message = obj["message"];
    if (obj['objectData'] != null) {
      objectData = User.map(obj['objectData']);
    }
  }

  factory LoginRegister.fromJson(dynamic json) {
    if (json['objectData'] != '') {
      return LoginRegister(
        status: json['status'],
        message: json['message'],
        objectData: User.fromJson(
          json['objectData'],
        ),
      );
    } else {
      return LoginRegister(
        status: json['status'],
        message: json['message'],
      );
    }
  }
}

class User {
  String? prefixName;
  String? firstName;
  String? lastName;
  String? email;
  String? category;
  String? code;
  String? username;
  String? password;
  bool? isActive;
  String? status;
  String? createBy;
  String? createDate;
  String? imageUrl;
  String? updateBy;
  String? updateDate;
  String? birthDay;
  String? phone;
  String? facebookID;
  String? googleID;
  String? lineID;
  String? appleID;
  String? line;
  String? sex;
  String? address;
  String? tambonCode;
  String? tambon;
  String? amphoeCode;
  String? amphoe;
  String? provinceCode;
  String? province;
  String? postnoCode;
  String? postno;
  String? job;
  String? idcard;
  String? countUnit;
  String? lv0;
  String? lv1;
  String? lv2;
  String? lv3;
  String? lv4;
  String? linkAccount;
  String? officerCode;
  bool? checkOrganization;

  User.map(dynamic json) {
    prefixName = json['prefixName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    category = json['category'];
    code = json['code'];
    username = json['username'];
    password = json['password'];
    isActive = json['isActive'];
    status = json['status'];
    createBy = json['createBy'];
    createDate = json['createDate'];
    imageUrl = json['imageUrl'];
    updateBy = json['updateBy'];
    updateDate = json['updateDate'];
    birthDay = json['birthDay'];
    phone = json['phone'];
    facebookID = json['facebookID'];
    googleID = json['googleID'];
    lineID = json['lineID'];
    appleID = json['appleID'];
    line = json['line'];
    sex = json['sex'];
    address = json['address'];
    tambonCode = json['tambonCode'];
    tambon = json['tambon'];
    amphoeCode = json['amphoeCode'];
    amphoe = json['amphoe'];
    provinceCode = json['provinceCode'];
    province = json['province'];
    postnoCode = json['postnoCode'];
    postno = json['postno'];
    job = json['job'];
    idcard = json['idcard'];
    countUnit = json['countUnit'];
    lv0 = json['lv0'];
    lv1 = json['lv1'];
    lv2 = json['lv2'];
    lv3 = json['lv3'];
    lv4 = json['lv4'];
    linkAccount = json['linkAccount'];
    officerCode = json['officerCode'];
    checkOrganization = json['checkOrganization'];
  }

  static Map<String, dynamic> toMap(LoginRegister loginRegister) {
    var map = <String, dynamic>{};
    map['prefixName'] = loginRegister.objectData!.prefixName;
    map['firstName'] = loginRegister.objectData!.firstName;
    map['lastName'] = loginRegister.objectData!.lastName;
    map['email'] = loginRegister.objectData!.email;
    map['category'] = loginRegister.objectData!.category;
    map['code'] = loginRegister.objectData!.code;
    map['username'] = loginRegister.objectData!.username;
    map['password'] = loginRegister.objectData!.password;
    map['isActive'] = loginRegister.objectData!.isActive;
    map['status'] = loginRegister.objectData!.status;
    map['createBy'] = loginRegister.objectData!.createBy;
    map['createDate'] = loginRegister.objectData!.createDate;
    map['imageUrl'] = loginRegister.objectData!.imageUrl;
    map['updateBy'] = loginRegister.objectData!.updateBy;
    map['updateDate'] = loginRegister.objectData!.updateDate;
    map['birthDay'] = loginRegister.objectData!.birthDay;
    map['phone'] = loginRegister.objectData!.phone;
    map['facebookID'] = loginRegister.objectData!.facebookID;
    map['googleID'] = loginRegister.objectData!.googleID;
    map['lineID'] = loginRegister.objectData!.lineID;
    map['appleID'] = loginRegister.objectData!.appleID;
    map['line'] = loginRegister.objectData!.line;
    map['sex'] = loginRegister.objectData!.sex;
    map['address'] = loginRegister.objectData!.address;
    map['tambonCode'] = loginRegister.objectData!.tambonCode;
    map['tambon'] = loginRegister.objectData!.tambon;
    map['amphoeCode'] = loginRegister.objectData!.amphoeCode;
    map['amphoe'] = loginRegister.objectData!.amphoe;
    map['provinceCode'] = loginRegister.objectData!.provinceCode;
    map['province'] = loginRegister.objectData!.province;
    map['postnoCode'] = loginRegister.objectData!.postnoCode;
    map['postno'] = loginRegister.objectData!.postno;
    map['job'] = loginRegister.objectData!.job;
    map['idcard'] = loginRegister.objectData!.idcard;
    map['countUnit'] = loginRegister.objectData!.countUnit;
    map['lv0'] = loginRegister.objectData!.lv0;
    map['lv1'] = loginRegister.objectData!.lv1;
    map['lv2'] = loginRegister.objectData!.lv2;
    map['lv3'] = loginRegister.objectData!.lv3;
    map['lv4'] = loginRegister.objectData!.lv4;
    map['linkAccount'] = loginRegister.objectData!.linkAccount;
    map['officerCode'] = loginRegister.objectData!.officerCode;
    map['checkOrganization'] = loginRegister.objectData!.checkOrganization;
    return map;
  }

  factory User.fromJson(dynamic json) {
    return User(
      prefixName: json['prefixName'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      category: json['category'] ?? '',
      code: json['code'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      isActive: json['isActive'] ?? '',
      status: json['status'] ?? '',
      createBy: json['createBy'] ?? '',
      createDate: json['createDate'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      updateBy: json['updateBy'] ?? '',
      updateDate: json['updateDate'] ?? '',
      birthDay: json['birthDay'] ?? '',
      phone: json['phone'] ?? '',
      facebookID: json['facebookID'] ?? '',
      googleID: json['googleID'] ?? '',
      lineID: json['lineID'] ?? '',
      appleID: json['appleID'] ?? '',
      line: json['line'] ?? '',
      sex: json['sex'] ?? '',
      address: json['address'] ?? '',
      tambonCode: json['tambonCode'] ?? '',
      tambon: json['tambon'] ?? '',
      amphoeCode: json['amphoeCode'] ?? '',
      amphoe: json['amphoe'] ?? '',
      provinceCode: json['provinceCode'] ?? '',
      province: json['province'] ?? '',
      postnoCode: json['postnoCode'] ?? '',
      postno: json['postno'] ?? '',
      job: json['job'] ?? '',
      idcard: json['idcard'] ?? '',
      countUnit: json['countUnit'] ?? '',
      lv0: json['lv0'] ?? '',
      lv1: json['lv1'] ?? '',
      lv2: json['lv2'] ?? '',
      lv3: json['lv3'] ?? '',
      lv4: json['lv4'] ?? '',
      linkAccount: json['linkAccount'] ?? '',
      officerCode: json['officerCode'] ?? '',
      checkOrganization: json['checkOrganization'] ?? false,
    );
  }

  User({
    this.prefixName,
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
    this.appleID,
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
    this.linkAccount,
    this.officerCode,
    this.checkOrganization,
  });

  Map<String, dynamic> toJson() => {
        'prefixName': prefixName,
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
        'appleID': appleID,
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
        'linkAccount': linkAccount,
        'officerCode': officerCode,
        'checkOrganization': checkOrganization,
      };

  save() => debugPrint('saving user using a web service');
}

class DataUser {
  String? facebookID;
  String? appleID;
  String? googleID;
  String? lineID;
  String? email;
  String? imageUrl;
  String? category;
  String? username;
  String? password;
  String? prefixName;
  String? firstName;
  String? lastName;

  // DataUser.map(dynamic json) {
  //   if (json['facebookID'] != null) {
  //     this.facebookID = json['facebookID'];
  //   }
  //   this.firstName = json['firstName'];
  //   this.lastName = json['lastName'];
  //   this.email = json['email'];
  //   this.category = json['category'];
  //   this.username = json['username'];
  //   this.password = json['password'];
  //   this.imageUrl = json['imageUrl'];
  //   this.googleID = json['googleID'];
  //   this.lineID = json['lineID'];
  //   this.appleID = json['appleID'];
  // }

  // DataUser({
  //   this.email,
  //   this.imageUrl,
  //   this.category,
  //   this.username,
  //   this.password,
  //   this.prefixName,
  //   this.firstName,
  //   this.lastName,
  //   this.facebookID,
  //   this.appleID,
  //   this.googleID,
  //   this.lineID,
  // });
}
