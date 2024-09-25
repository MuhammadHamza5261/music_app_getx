import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper{

static const String isLoggedInKey = "isLoggedIn";


 static Future<void> setLoggedKey(bool isLoggedIn) async{

   final SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setBool(isLoggedInKey, isLoggedIn);

 }

 static Future<bool> getLoggedKey() async{

   final SharedPreferences pref = await SharedPreferences.getInstance();
   return pref.getBool(isLoggedInKey) ?? false;

 }

 static Future<void> clearLoggedKey() async{

   final SharedPreferences pref = await SharedPreferences.getInstance();
   pref.remove(isLoggedInKey);


 }





}