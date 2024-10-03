import 'dart:async';
import 'package:flutter/material.dart';
import 'package:getx_music_app/config/shared_pref.dart';
import 'package:getx_music_app/screeens/home_screen.dart';
import 'package:getx_music_app/singleton.dart';
import '../config/navigation.dart';
import 'login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {

    super.initState();
    _isCheckedStatus();

  }


  void _isCheckedStatus() async{

     bool isLoggedKey = await SharedPrefClient.getLoggedKey();
     Timer(const Duration(seconds: 5), () async {
       if (isLoggedKey)  {
          await SharedPrefClient.getLoginEmail();

         NavigationHelper.navigateToScreen(context, const HomeScreen());
       } else {
         NavigationHelper.navigateToScreen(context, const LoginScreen());
       }
     });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
          child: Column(

            children: [
              SizedBox(
                height: 40,
              ),
              Center(
                child: Image.asset("assets/images/fjwj.png",),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text('Music App',style: TextStyle(
                  fontSize: 30
                ),),
              ),

            ],
          ),
        ),
      ),

    );
  }
}
