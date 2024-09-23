import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../screeens/home_screen.dart';
import '../singleton.dart';

class LoginController extends GetxController {


  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool loading = false.obs;
  RxString error = "".obs;

  void loginApi() async {
    loading.value = true;

    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: <String, String>{
          "Content-type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(<String, dynamic>{
          "username": nameController.text,
          "password": passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        loading.value = false;

        // Store the username in the Singleton instance
        Singleton.instance.userName = nameController.text;

        // Navigate to the HomeScreen using Get.off()
        Get.off(() => const HomeScreen());

        Get.snackbar(
          'Login Successful',
          'Welcome!',
          backgroundColor: Colors.blue,
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
