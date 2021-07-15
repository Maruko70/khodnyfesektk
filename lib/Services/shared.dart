import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _sharedPrefs;
  init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  String get uid => _sharedPrefs.getString(keyUid) ?? "";

  set uid(String value) {
    _sharedPrefs.setString(keyUid, value);
  }

  String get name => _sharedPrefs.getString(keyName) ?? "";

  set name(String value) {
    _sharedPrefs.setString(keyName, value);
  }

  String get email => _sharedPrefs.getString(keyEmail) ?? "";

  set email(String value) {
    _sharedPrefs.setString(keyEmail, value);
  }

  String get gender => _sharedPrefs.getString(keyGender) ?? "";

  set gender(String value) {
    _sharedPrefs.setString(keyGender, value);
  }

  String get phone => _sharedPrefs.getString(keyPhone) ?? "";

  set phone(String value) {
    _sharedPrefs.setString(keyPhone, value);
  }

  String get pp => _sharedPrefs.getString(keyProfile) ?? "";

  set pp(String value) {
    _sharedPrefs.setString(keyProfile, value);
  }
  
  bool get smoker => _sharedPrefs.getBool(keySmoker) ?? false;

  set smoker(bool value) {
    _sharedPrefs.setBool(keySmoker, value);
  }

  bool get driver => _sharedPrefs.getBool(keyDriver) ?? false;

  set driver(bool value) {
    _sharedPrefs.setBool(keyDriver, value);
  }

  bool get loggedin => _sharedPrefs.getBool(keyLoggedin) ?? false;

  set loggedin(bool value) {
    _sharedPrefs.setBool(keyLoggedin, value);
  }

  void clearShared() {
    loggedin = false;
    name = "";
    email = "";
    uid = "";
    phone = "";
    gender = "";
    smoker = false;
    driver = false;
    pp = "";
  }
}

final sharedPrefs = SharedPrefs();
const String keyUid = "key_uid";
const String keyName = "key_name";
const String keyEmail = "key_email";
const String keyLoggedin = "key_loggedin";
const String keyProfile = "key_profile";
const String keyGender = "key_gender";
const String keyPhone = "key_phone";
const String keySmoker = "key_smoker";
const String keyDriver = "key_driver";