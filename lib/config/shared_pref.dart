import 'package:getx_music_app/singleton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefClient{


  static const String _isLoggedKey = "isLoggedKey";
  static const String _isLoginEmail = "isLoginEmail";


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

  // set login email

  static Future<void> setLoginEmail(String email) async{

    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(_isLoginEmail, email);
    Singleton.instance.email = email ;

  }

  static Future<void> getLoginEmail() async{

    SharedPreferences sp = await SharedPreferences.getInstance();
    String? data = sp.getString(_isLoginEmail) ;
    if(data != null) {
      Singleton.instance.email = data ;
    }

  }














}