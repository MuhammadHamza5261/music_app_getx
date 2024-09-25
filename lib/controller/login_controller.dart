import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_music_app/config/shared_pref.dart';
import 'package:http/http.dart' as http;
import '../screeens/home_screen.dart';
import '../singleton.dart';



class LoginController extends GetxController {


  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  RxBool loading = false.obs;
  RxString error = "".obs;

  void loginApi() async {
    loading.value = true;

    try {

      final response = await http.post(Uri.parse('https://reqres.in/api/login'),

        headers: <String, String>{
          "Content-type": "application/json",
          "Accept": "application/json",
        },

        body: jsonEncode(<String, dynamic>{

          "email": emailController.value.text,
          "password": passwordController.value.text,

        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {

        loading.value = false;

         Singleton.instance.email = emailController.text;

         await SharedPrefClient.setLoggedKey(true);

        Get.off(() => const HomeScreen());

        Get.snackbar(
          'Login Successful',
          'Welcome!',
          backgroundColor: Colors.green.shade600,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        loading.value = false;
        error.value = data['error'] ?? 'Unknown error';
        Get.snackbar(
          'Login Failed',
          data['error'],
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar(
        'Exception',
        e.toString(),
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
