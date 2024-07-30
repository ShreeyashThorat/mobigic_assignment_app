import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  String? userid;
  @HiveField(1)
  String? email;
  @HiveField(2)
  String? firstName;
  @HiveField(3)
  String? lastName;
  @HiveField(4)
  String? dob;
  @HiveField(5)
  String? token;

  UserModel(
      {this.userid,
      this.email,
      this.firstName,
      this.lastName,
      this.dob,
      this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    userid = json['userid'] ?? "";
    email = json['email'] ?? "";
    firstName = json['firstName'] ?? "";
    lastName = json['lastName'] ?? "";
    dob = json['dob'] ?? "";
    token = json['token'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userid'] = userid ?? "";
    data['email'] = email ?? "";
    data['firstName'] = firstName ?? "";
    data['lastName'] = lastName ?? "";
    data['dob'] = dob ?? "";
    data['token'] = token ?? "";
    return data;
  }
}
