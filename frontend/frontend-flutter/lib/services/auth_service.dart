import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart'; // Untuk cek jika di web
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  // Deteksi apakah sedang berjalan di web
 final String baseUrl = "http://localhost:8080/api";


  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data['token']);
        return data['token'];
      } else {
        print("Login gagal: ${response.statusCode}");
        print("Response: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error login: $e");
      return null;
    }
  }
}
