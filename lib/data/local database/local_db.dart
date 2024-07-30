import '../model/user model/user_model.dart';
import 'package:hive/hive.dart';

class LocalDatabase {
  static Future<void> saveUserData(UserModel userData) async {
    var userBox = await Hive.openBox<UserModel>('userData');
    await userBox.put('user_data', userData);
    await userBox.close();
  }

  static Future<UserModel?> getUserData() async {
    var userBox = await Hive.openBox<UserModel>('userData');
    var userData = userBox.get('user_data');
    await userBox.close();
    return userData;
  }

  static Future<void> deleteUserData() async {
    var userBox = await Hive.openBox<UserModel>('userData');
    await userBox.clear();
    await userBox.close();
  }
}
