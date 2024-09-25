import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefClient{


  static const String _isLoggedKey = "isLoggedKey";


  static Future<void> setLoggedKey(bool isLoggedKey) async{

    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(_isLoggedKey, isLoggedKey);

  }

  static Future<bool> getLoggedKey() async{

    final SharedPreferences pref = await SharedPreferences.getInstance();
     return pref.getBool(_isLoggedKey) ?? false;

  }

  static Future<void> clearLoggedKey() async{

    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(_isLoggedKey);

  }













}